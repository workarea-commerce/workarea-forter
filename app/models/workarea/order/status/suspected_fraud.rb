module Workarea
  class Order
    module Status
      class SuspectedFraud
        include StatusCalculator::Status

        def in_status?
          !order.placed? && order.flagged_for_fraud? && !order.canceled?
        end
      end
    end
  end
end
