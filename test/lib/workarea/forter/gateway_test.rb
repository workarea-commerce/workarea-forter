require "test_helper"

module Workarea
  module Forter
    class GatewayTest < Workarea::TestCase
      include ForterApiConfig

      def gateway
        Workarea::Forter::Gateway.new(
          secret_key: Rails.application.secrets.forter[:secret_key],
          site_id: site_id
        )
      end

      def test_get_decision
        VCR.use_cassette("forter/get_decision", match_requests_on: [:method, :uri]) do
          order = create_placed_forter_order(id: "fortertest1234", email: "approve@forter.com")

          forter_decision = Forter::Decision.find order.id
          response = forter_decision.responses.first
          assert response.decision_response.success?
        end
      end

      def test_update_order_status
         VCR.use_cassette("forter/update_status", match_requests_on: [:method, :uri]) do
          order = create_placed_forter_order(id: "statusfortertest12345", email: "approve@forter.com")

          hsh = Forter::Order.new(order).to_h

          response = gateway.create_decision(order.id, hsh)
          assert(response.success?)


          hsh = {
            orderId: order.id,
            eventTime: Time.new.to_i * 1000,
            updatedStatus: "CANCELED_BY_MERCHANT"
          }

          update_status_response = gateway.update_order_status(order.id, hsh)
          assert(update_status_response.success?)
        end
      end
    end
  end
end
