require 'test_helper'

module Workarea
  module Foter
    class OrderTest < Workarea::TestCase
      def test_to_h
         Workarea.with_config do |config|
          config.forter.credit_card_gateway_name = "cc_processor"

          user = create_user(id: 'u-1234', first_name: 'jeffy', last_name: 'tester')
          order = create_placed_forter_order(overrides = { id: '1234', user_id: user.id })
          hsh = Forter::Order.new(order).to_h

          payment = Workarea::Payment.find('1234')
          shipping = Workarea::Shipping.find_by_order('1234')

          assert_equal(order.id, hsh[:orderId])
          assert_equal("WEB", hsh[:orderType])

          assert_equal(payment.address.first_name, hsh[:primaryRecipient][:personalDetails][:firstName])
          assert_equal(payment.address.last_name, hsh[:primaryRecipient][:personalDetails][:lastName])

          assert_equal(shipping.address.street, hsh[:primaryRecipient][:address][:address1])
          assert_equal(shipping.address.city, hsh[:primaryRecipient][:address][:city])
          assert_equal(shipping.address.country.alpha2, hsh[:primaryRecipient][:address][:country])

          assert_equal(order.total_price.to_s, hsh[:totalAmount][:amountUSD])

          assert_equal(1, hsh[:cartItems].size)

          assert_equal(1, hsh[:payment].size)
          assert_equal(order.total_price.to_s, hsh[:payment].first[:amount][:amountUSD])

          assert_equal("cc_processor", hsh[:payment].first[:creditCard][:paymentGatewayData][:gatewayName])
          assert(hsh[:payment].first[:creditCard][:paymentGatewayData][:gatewayTransactionId].present?)

          assert_equal(user.first_name, hsh[:accountOwner][:firstName])
          assert_equal(user.last_name, hsh[:accountOwner][:lastName])
          assert_equal(user.email, hsh[:accountOwner][:email])
          assert_equal(user.id, hsh[:accountOwner][:accountId])

          assert_equal("123ABC", hsh[:connectionInformation][:forterTokenCookie])
        end
      end

      def test_to_h_with_no_shipping_address
        order = create_placed_forter_order(overrides = { id: '1234' })
        payment = Workarea::Payment.find('1234')

        #remove the shipping so it falls back to payment address
        shipping = Workarea::Shipping.find_by_order('1234')
        shipping.delete

        hsh = Forter::Order.new(order).to_h
        assert_equal(payment.address.street, hsh[:primaryRecipient][:address][:address1])
        assert_equal(payment.address.city, hsh[:primaryRecipient][:address][:city])
        assert_equal(payment.address.country.alpha2, hsh[:primaryRecipient][:address][:country])
      end

      def test_to_h_multiple_tenders
        user = create_user(id: 'u-12345', first_name: 'jeffy', last_name: 'tester')
        order = create_placed_forter_order(overrides = { id: '1234', user_id: user.id }, options = { store_credit_amount: 5.00 })
        hsh = Forter::Order.new(order).to_h

        assert_equal(2, hsh[:payment].size)
        assert(hsh[:payment].all? { |p| p[:billingDetails].present? })
      end

      def test_to_h_guest_order
        order = create_placed_order(id: '1234')
        payment = Workarea::Payment.find('1234')

        hsh = Forter::Order.new(order).to_h

        assert_equal(payment.address.first_name, hsh[:accountOwner][:firstName])
        assert_equal(payment.address.last_name, hsh[:accountOwner][:lastName])
        assert_equal(order.email, hsh[:accountOwner][:email])
      end

      def test_to_h_promo_code
        order = create_placed_order(id: '1234')
        order.promo_codes = ['1234']

        hsh = Forter::Order.new(order).to_h
        assert_equal('1234', hsh[:totalDiscount][:couponCodeUsed])
      end
    end
  end
end
