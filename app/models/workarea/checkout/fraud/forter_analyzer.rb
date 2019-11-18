module Workarea
  class Checkout
    module Fraud
      class ForterAnalyzer < Analyzer
        ERROR_STATUSES = 500..599
        MAX_RETRIES = 2

        def make_decision
          decision = Workarea::Order::FraudDecision.new
          order_hash = Forter::Order.new(order).to_h
          count = 1

          begin
            fraud_response = Forter.gateway.create_decision(order.id, order_hash)
            body = JSON.parse(fraud_response.body)

            forter_decision_action = if body["action"] == "decline"
              :declined
            else
              body["action"].optionize.to_sym
            end

            raise if ERROR_STATUSES.include? fraud_response.status

            decision.message = body["message"]
            decision.decision = forter_decision_action
            decision.response = body

            response = Forter::DecisionResponse.new(body)
            decision.responses.build(decision_response: response)
            decision

          rescue => error
            forter_error_decision.responses.build(
              timed_out: error.is_a?(Faraday::Error::TimeoutError),
              error: error.message
            )
            forter_error_decision

            if count < MAX_RETRIES
              count += 1
              retry
            else
              raise error
            end
          end
        end

        private

        def forter_error_decision
          @forter_error_decision ||= error_decision(nil)
        end
      end
    end
  end
end
