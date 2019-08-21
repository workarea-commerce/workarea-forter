require 'test_helper'

module Workarea
  class Checkout
    class ForterCollectPaymentTest < TestCase
      setup :create_models

      def test_rescuing_timeout_errors
        Workarea::Forter::BogusGateway
          .any_instance
          .stubs(:create_decision)
          .raises(Faraday::Error::TimeoutError)
        refute(@collect_payment.purchase)

        forter_decision = Forter::Decision.find(@order.id)
        assert_equal(2, forter_decision.responses.size)
        forter_decision.responses.each do |response|
          assert response.timed_out
        end
      end

      def test_with_one_timeout
        normal_response = Forter.gateway.create_decision(@order.id, Forter::Order.new(@order).to_h)
        Workarea::Forter::BogusGateway
          .any_instance
          .stubs(:create_decision)
          .raises(Faraday::Error::TimeoutError)
          .then
          .returns(normal_response)

        refute(@collect_payment.purchase)
        forter_decision = Forter::Decision.find(@order.id)
        assert_equal(2, forter_decision.responses.size)

        assert(forter_decision.responses.first.timed_out)
        refute(forter_decision.responses.second.timed_out)
      end

      private

        def create_models
          @order = Order.create!(email: 'test@workarea.com', total_price: 5.to_m)
          @checkout = Checkout.new(@order)
          @payment = Payment.create!(
            id: @order.id,
            address: {
              first_name: "Ben",
              last_name: "Crouse",
              street: "22 S 3rd St",
              city: "Philadelphia",
              region: "PA",
              country: Country['US'],
              postal_code: 19106
            }
          )
          @collect_payment = CollectPayment.new(@checkout)
        end
    end
  end
end
