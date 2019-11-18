require 'test_helper'

module Workarea
  class Forter::UpdateStatusTest < TestCase
    def test_decision_status_update
      order = create_placed_order

      details_hash = {
        orderId: 1234,
        eventTime: Time.new.to_i * 1000,
        updatedStatus: "CANCELED_BY_MERCHANT"
      }

      Workarea::Forter::UpdateStatus.new.perform(order.id, details_hash)

      order.reload

      assert_equal("CANCELED_BY_MERCHANT", order.fraud_decision.external_order_status)
    end
  end
end
