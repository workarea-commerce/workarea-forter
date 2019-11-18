require 'test_helper'

module Workarea
  module Admin
    class ForterOrderIntegrationTest < Workarea::IntegrationTest
      include Admin::IntegrationTest

      def test_shows_decision
        order = create_placed_forter_order(email: 'approve@workarea.com')

        get admin.order_path(order)
        assert(response.body.include?("approve"))
      end

      def test_shows_error_decision
        order = create_placed_forter_order(email: 'error@workarea.com')

        get admin.fraud_order_path(order)
        message = order.fraud_decision.response.errors.first["message"]
        assert(response.body.include?(message))
      end

      def test_returns_forter_order_details
        order = create_placed_forter_order(email: 'approve@workarea.com')
        decision = order.fraud_decision
        get admin.fraud_order_path(order)

        assert(response.body.include?(decision.response.body_message))
        assert(response.body.include?(decision.response.action))
        assert(response.body.include?(decision.response.reason_code.to_s))
        assert(response.body.include?(decision.external_order_status))
        assert(response.body.include?(t('workarea.admin.orders.forter.console')))
      end
    end
  end
end
