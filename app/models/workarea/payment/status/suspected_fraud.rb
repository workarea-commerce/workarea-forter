module Workarea
  class Payment
    module Status
      class SuspectedFraud
        include Workarea::StatusCalculator::Status

        def in_status?
          order.flagged_for_fraud?
        end
      end
    end
  end
end
