require 'test_helper'
module Workarea
  class Payment
    class ForterCreditCardTest < TestCase

      def credit_card
        @credit_card ||= Workarea::Payment::Tender::CreditCard.new
      end

      def test_valid?
        credit_card.number = 4111111111111111
        credit_card.valid?
        assert(credit_card.display_number.present?)
        assert(credit_card.issuer.present?)
        assert(credit_card.bin.present?)
      end
    end
  end
end
