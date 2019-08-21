require 'test_helper'

module Workarea
  class ForterAuthorizeCimResponseCodeIntegrationTest < Workarea::IntegrationTest
    if Workarea::Plugin.installed?(:AuthorizeCim)
      include ForterApiConfig
      include AuthorizeCimGatewayVCRConfig

      def test_response_code
        VCR.use_cassette 'forter/integration/authorize_net_response_code' do

          tender.amount = 5.to_m
          transaction = tender.build_transaction(action: 'authorize')
          operation = Payment::Authorize::CreditCard.new(tender, transaction)
          operation.complete!
          transaction.save!

          response_code = Workarea.config.forter.response_code[gateway_class].call(transaction)
          assert_equal('1', response_code)
        end
      end

      private

      def gateway_class
        gateway.class.to_s
      end

      def gateway
        Workarea.config.gateways.credit_card
      end

      def payment
        @payment ||=
          begin
            profile = create_payment_profile
            create_payment(
              profile_id: profile.id,
              address: {
                first_name: 'Ben',
                last_name: 'Crouse',
                street: '22 s. 3rd st.',
                city: 'Philadelphia',
                region: 'PA',
                postal_code: '19106',
                country: Country['US']
              }
            )
          end
      end

      def tender
        @tender ||=
          begin
            payment.set_address(first_name: 'Ben', last_name: 'Crouse')

            payment.build_credit_card(
              number: 4111111111111111,
              month: 1,
              year: Time.current.year + 1,
              cvv: 999
            )

            payment.credit_card
          end
      end
    end
  end
end
