module Workarea
  module Forter
    module Tender
      class General
        attr_reader :tender, :options

        def initialize(tender, options = {})
          @tender = tender
          @options = options
        end

        # @return Hash
        def to_h
          {
            generalPaymentMethod: {
              name: tender.slug.to_s,
              payload: transaction.response.params
            }
          }
        end

        private
          def transaction
            @transaction ||= tender.transactions.sort_by { |t| t.created_at.to_i }.last
          end
      end
    end
  end
end
