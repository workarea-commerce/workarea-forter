require 'test_helper'

module Workarea
  module Storefront
    class ForterIntegrationTest < Workarea::IntegrationTest
      def test_decision_approved
        complete_checkout("approved@workarea.com", 'W3blinc1')

        order = Workarea::Order.last
        payment = Workarea::Payment.last

        order.reload
        decision = order.fraud_decision

        refute(decision.response.suspected_fraud?)

        refute(order.fraud_suspected?)
        refute(payment.fraud_suspected?)
      end

      def test_decision_not_reviewed
        user = create_user(email: "notreviewed@workarea.com", password: 'W3blinc1')
        complete_checkout("notreviewed@workarea.com", 'W3blinc1')

        order = Workarea::Order.last
        payment = Workarea::Payment.last

        decision = order.fraud_decision

        refute(payment.fraud_suspected?)
        refute(decision.response.suspected_fraud?)
      end

      def test_decision_declined
        user = create_user(email: "decline@workarea.com", password: 'W3blinc1')
        complete_checkout("decline@workarea.com", 'W3blinc1')

        order = Workarea::Order.last

        decision = order.fraud_decision

        assert(decision.response.suspected_fraud?)

        payment = Workarea::Payment.last
        transaction = payment.tenders.first.transactions.first

        assert(transaction.cancellation.present?)

        payment.reload

        assert(order.fraud_suspected?)
        assert_equal(:suspected_fraud, order.status)

        assert(payment.fraud_suspected?)
        assert_equal(:suspected_fraud, payment.status)
      end

      def test_gateway_error
        user = create_user(email: "error@workarea.com", password: 'W3blinc1')
        complete_checkout("error@workarea.com", 'W3blinc1')

        order = Workarea::Order.last
        payment = Workarea::Payment.last

        decision = order.fraud_decision

        refute(payment.fraud_suspected?)
        refute(decision.response.suspected_fraud?)
        assert(decision.response.errors.present?)
      end

      def product
        @product ||= create_product(
          name: 'Integration Product',
          variants: [
            { sku: 'SKU1', tax_code: '001', regular: 5.to_m }
          ]
        )
      end

      def complete_checkout(email = nil, password = nil)
        if Shipping::Service.blank?
          create_shipping_service(
            name: 'Ground',
            tax_code: '001',
            rates: [{ price: 7.to_m }]
          )
        end

        post storefront.cart_items_path,
          params: {
            product_id: product.id,
            sku: product.skus.first,
            quantity: 2
          }

        if email.present? && password.present?
          post storefront.login_path,
            params: { email: email, password: password }
        end

        patch storefront.checkout_addresses_path,
          params: {
            email: email,
            billing_address: {
              first_name:   'Ben',
              last_name:    'Crouse',
              street:       '12 N. 3rd St.',
              city:         'Philadelphia',
              region:       'PA',
              postal_code:  '19106',
              country:      'US',
              phone_number: '2159251800'
            },
            shipping_address: {
              first_name:   'Ben',
              last_name:    'Crouse',
              street:       '22 S. 3rd St.',
              city:         'Philadelphia',
              region:       'PA',
              postal_code:  '19106',
              country:      'US',
              phone_number: '2159251800'
            }
          }

        patch storefront.checkout_place_order_path,
          params: {
            payment: 'new_card',
            credit_card: {
              number: '1',
              month:  1,
              year:   2020,
              cvv:    '999'
            }
          }
      end
    end
  end
end
