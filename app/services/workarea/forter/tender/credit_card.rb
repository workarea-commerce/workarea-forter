module Workarea
  module Forter
    module Tender
      class CreditCard
        attr_reader :tender, :options

        def initialize(tender, options = {})
          @tender = tender
          @options = options
        end

        # @return Hash
        def to_h
          return {} unless tender.present?
          {
            creditCard: {
              bin: tender.bin,
              lastFourDigits: tender.display_number[-4, 4].to_s,
              expirationMonth: cc_month(tender.month),
              expirationYear: tender.year.to_s,
              cardBrand: tender.issuer,
              nameOnCard: "#{address.first_name} #{address.last_name}",
              paymentGatewayData: payment_gateway_data
            }.merge!(verification_results)
          }
        end

        private

          def address
            payment.address
          end

          def cc_month(month)
            month < 10 ? "0#{month}" : month.to_s
          end

          def payment
            @payment ||= tender.payment
          end

          def transaction
            @transaction ||= tender.transactions.sort_by { |t| t.created_at.to_i }.last
          end

          def verification_results
            return {} unless tender.transactions.present?

            return {} unless transaction.response.avs_result.present?
            {
              verificationResults: {
                avsFullResult: transaction.response.avs_result["code"].to_s,
                cvvResult: transaction.response.cvv_result["code"].to_s,
                authorizationCode: transaction.response.authorization.to_s,
                processorResponseText: transaction.response.message.to_s,
                processorResponseCode: forter_authorization_code.to_s
              }
            }

          rescue => e
            Forter.log_error(e)
            {
              verificationResults: {}
            }
          end

          def forter_authorization_code
            gateway_class = Workarea.config.gateways.credit_card.class.to_s
            Workarea.config.forter.response_code[gateway_class].call(transaction) rescue nil
          end

          def payment_gateway_data
            return unless tender.transactions.present? && transaction.present?

            {
              gatewayName: Workarea::Forter.config.credit_card_gateway_name || "not specified",
              gatewayTransactionId: transaction.response.authorization.to_s
            }
          end
      end
    end
  end
end
