require 'test_helper'

module Workarea
   class Payment::ForterSavedCreditCardTest < TestCase
    def test_save
      card = Workarea::Payment::SavedCreditCard.new(
        profile: create_payment_profile(reference: '234'),
        number: '4111111111111111',
        cvv: '123',
        month: 12,
        year: Time.current.year + 1,
        first_name: 'Robert',
        last_name: 'Clams'
      )

      card.save
      assert(card.tokenized?)
      assert(card.bin.present?)
      assert_equal('411111', card.bin)

      profile = create_payment_profile
      current_default = create_saved_credit_card(profile: profile, default: true)
      new_default = create_saved_credit_card(profile: profile, default: true)

      current_default.reload
      new_default.reload

      refute(current_default.default?)
      assert(new_default.default?)
    end
  end
end
