module Workarea
  module Forter
    class Payment
      attr_reader :payment, :options

      def initialize(payment, options = {})
        @payment = payment
        @options = options
      end

      # @return Array
      def to_a
        payment_tenders.map do | tender|

          tender_hash = build_tender_details(tender)

          billing_details_hash = {
            billingDetails: {
              personalDetails: {
                firstName: address.first_name,
                lastName: address.last_name
              },
            address: forter_address,
            phone: [{ phone: address.phone_number.to_s }]
            },
            amount: { amountUSD: tender.amount.to_s }
          }

          tender_hash.merge!(billing_details_hash)
        end
      end

      private

        def build_tender_details(tender)
          case tender.slug
          when :credit_card
            Tender::CreditCard.new(tender).to_h
          when :gift_card
            Tender::GiftCard.new(tender).to_h
          when :store_credit
            Tender::StoreCredit.new(tender).to_h
          when :paypal
            Tender::Paypal.new(tender).to_h
          else
            Tender::General.new(tender).to_h
          end
        end

        def address
          payment.address
        end

        def forter_address
          {
            address1: address.street,
            address2: address.street_2,
            city: address.city,
            country: address.country.alpha2,
            zip: address.postal_code,
            region: address.region
          }
        end

        def payment_tenders
          payment.tenders.reject { |t| t.transactions.empty? }
        end
    end
  end
end
