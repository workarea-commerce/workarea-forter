require 'test_helper'

module Workarea
    class ForterPaymentTest < TestCase

    def response
      ActiveMerchant::Billing::Response.new(
        true,
        'Message',
        {},
        { authorization: 'ABCDEFG' }
      )
    end

    def test_rollback
      payment = Payment.new(
        address: {
          first_name: 'Ben',
          last_name: 'Crouse',
          street: '22 S. 3rd St.',
          street_2: 'Second Floor',
          city: 'Philadelphia',
          region: 'PA',
          postal_code: '19106',
          country: 'US',
          phone_number: '2159251800'
        }
      )
      payment.profile = create_payment_profile(
        email: 'test@workarea.com',
        store_credit: 1.to_m
        )
      payment.build_store_credit

      payment.build_credit_card(
        number: '4111111111111111',
        month: 1,
        year: Time.current.year + 1,
        cvv: 999,
        amount: 9.to_m
      )

      payment.save!

      tender = payment.credit_card
      tender.build_transaction(amount: 10.to_m, success: true, action: 'authorize', response: response).save!

      store_credit_tender = payment.store_credit
      store_credit_tender.build_transaction(amount: 1.to_m, success: true, action: 'authorize', response: response).save!

      payment.rollback!

      transactions = payment.tenders.flat_map(&:transactions)

      assert(transactions.all? { |t| t.canceled_at.present? })
    end
  end
end
