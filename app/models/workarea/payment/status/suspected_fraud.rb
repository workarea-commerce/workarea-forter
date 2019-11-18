module Workarea
  class Payment
    module Status
      class SuspectedFraud
        include Workarea::StatusCalculator::Status

        def in_status?
          order.fraud_suspected?
        end
      end
    end
  end
end
