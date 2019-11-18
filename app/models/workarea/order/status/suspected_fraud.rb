module Workarea
  decorate Order::Status::SuspectedFraud, with: :forter do
    def in_status?
      super && !order.placed? && !order.canceled?
    end
  end
end
