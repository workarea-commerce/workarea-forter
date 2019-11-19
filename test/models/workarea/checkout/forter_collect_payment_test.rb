require 'test_helper'

module Workarea
  class Checkout
    class ForterCollectPaymentTest < TestCase
      setup :create_models

      def test_purchase
        @collect_payment.purchase
        @order.reload
        forter_decision = @order.fraud_decision
        assert_equal(1, forter_decision.responses.size)
        assert_equal(:approve, forter_decision.decision)
      end

      def test_rescuing_timeout_errors
        Workarea::Forter::BogusGateway
          .any_instance
          .stubs(:create_decision)
          .raises(Faraday::Error::TimeoutError)
        refute(@collect_payment.purchase)

        @order.reload
        forter_decision = @order.fraud_decision
        assert_equal(:no_decision, forter_decision.decision)

        assert_equal("An error occured during the fraud check: timeout", forter_decision.message)
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
