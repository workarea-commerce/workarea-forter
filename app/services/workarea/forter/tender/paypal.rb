module Workarea
  module Forter
    module Tender
      class Paypal

        class PaypalDependencyError < StandardError; end
        attr_reader :tender, :options

        def initialize(tender, options = {})
          @tender = tender
          @options = options
        end

        # @return Hash
        def to_h
          raise PaypalDependencyError.new("Paypal plugin not installed but paypal transaction detected") unless Plugin.installed?("Workarea::Paypal")
          {
            paypal: {
              payerId: tender.payer_id,
              fullPaypalResponsePayload: transaction.response.params,
              payerEmail:  tender.details["payer"],
              paymentStatus: transaction.response.params["payment_status"],
              paymentMethod:  transaction.response.params["payment_type"],
              payerAddressStatus: tender.details["address_status"],
              payerStatus: tender.details["payer_status"]
            }
          }
        end

        private

          def transaction
            @transaction ||= tender.transactions.detect { |t| t.success? }
          end
      end
    end
  end
end
