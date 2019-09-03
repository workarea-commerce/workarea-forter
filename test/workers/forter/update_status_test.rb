require 'test_helper'

module Workarea
  class Forter::UpdateStatusTest < TestCase
    def test_decision_status_update
      decision = Workarea::Forter::Decision.create(id: '1234')

      details_hash = {
        orderId: 1234,
        eventTime: Time.new.to_i * 1000,
        updatedStatus: "CANCELED_BY_MERCHANT"
      }

      Workarea::Forter::UpdateStatus.new.perform(decision.id, details_hash)

      decision.reload

      assert_equal("CANCELED_BY_MERCHANT", decision.external_order_status)
    end
  end
end
