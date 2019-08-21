require 'test_helper'

module Workarea
  module Storefront
    if Workarea::Plugin.installed?(:braintree)
      class ForterCheckoutSystemTest < Workarea::SystemTest
        include Storefront::SystemTest
        include ForterApiConfig
        include BraintreeGatewayVCRConfig

        def test_braintree_approved
          VCR.use_cassette('forter/system/braintree_approved', match_requests_on: [:host, :method]) do
            setup_checkout_specs
            start_guest_checkout

            fill_in 'email', with: 'approve@forter.com'
            fill_in_shipping_address
            click_button t('workarea.storefront.checkouts.continue_to_shipping')
            assert_current_path(storefront.checkout_shipping_path)

            click_button t('workarea.storefront.checkouts.continue_to_payment')
            assert_current_path(storefront.checkout_payment_path)

            fill_in_braintree_test_visa
            click_button t('workarea.storefront.checkouts.place_order')
            assert_current_path(storefront.checkout_confirmation_path)
          end
        end

        def test_braintree_not_reviewed
          VCR.use_cassette('forter/system/braintree_not_reviewed', match_requests_on: [:host, :method]) do
            setup_checkout_specs
            start_guest_checkout

            fill_in 'email', with: 'notreviewed@forter.com'
            fill_in_shipping_address
            click_button t('workarea.storefront.checkouts.continue_to_shipping')
            assert_current_path(storefront.checkout_shipping_path)

            click_button t('workarea.storefront.checkouts.continue_to_payment')
            assert_current_path(storefront.checkout_payment_path)

            fill_in_braintree_test_visa
            click_button t('workarea.storefront.checkouts.place_order')
            assert_current_path(storefront.checkout_confirmation_path)
          end
        end

        def test_braintree_declined
          VCR.use_cassette('forter/system/braintree_declined', match_requests_on: [:host, :method]) do
            setup_checkout_specs
            start_guest_checkout

            fill_in 'email', with: 'decline@forter.com'
            fill_in_shipping_address
            click_button t('workarea.storefront.checkouts.continue_to_shipping')
            assert_current_path(storefront.checkout_shipping_path)

            click_button t('workarea.storefront.checkouts.continue_to_payment')
            assert_current_path(storefront.checkout_payment_path)

            fill_in_braintree_test_visa
            click_button t('workarea.storefront.checkouts.place_order')
            assert_current_path(storefront.checkout_place_order_path)
          end
        end

        private

          def fill_in_braintree_test_visa
            fill_in 'credit_card[number]', with: '4111111111111111'
            next_year = (Time.current.year + 1).to_s
            select next_year, from: 'credit_card[year]'
            fill_in 'credit_card[cvv]', with: '999'
          end
      end
    end
  end
end
