require 'test_helper'

module Workarea
  module Adming
    class ForterSystemTest < Workarea::SystemTest
      include Admin::IntegrationTest

      def test_viewing_forter_order_admin
        checkout = create_purchasable_checkout
        order = checkout.order

        normal_response = Forter.gateway.create_decision(
          order.id,
          Forter::Order.new(order).to_h
        )
        Workarea::Forter::BogusGateway
          .any_instance
          .stubs(:create_decision)
          .raises(Faraday::Error::TimeoutError)
          .then
          .returns(normal_response)

        assert(checkout.place_order)

        visit admin.forter_order_path order

        assert page.has_content?("timeout")
      end
    end
  end
end
