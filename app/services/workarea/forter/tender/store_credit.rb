module Workarea
  module Forter
    module Tender
      class StoreCredit
        attr_reader :tender, :options

        def initialize(tender, options = {})
          @tender = tender
          @options = options
        end

        # @return Hash
        def to_h
          {
            creditUsed: {
              amountUSD: tender.amount.to_s
            }
          }
        end
      end
    end
  end
end
