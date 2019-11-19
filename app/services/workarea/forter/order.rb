module Workarea
  module Forter
    class Order
      attr_reader :order, :options

      def initialize(order, options = {})
        @order = order
        @options = options
      end

      # @return Hash
      def to_h
        hsh = {
          orderId: order.id,
          orderType: 'WEB',
          timeSentToForter: forter_export_time,
          checkoutTime: order.placed_at.to_i,
          primaryRecipient: {
            personalDetails: {
              firstName: payment.address.first_name,
              lastName: payment.address.last_name
            },
            address: primary_recipient_address,
            phone: [
              {
                phone: payment.address.phone_number.to_s
              }
            ]
          },
          totalAmount: {
            amountUSD: order.total_price.to_s
          },
          connectionInformation: {
            customerIP: order.ip_address,
            userAgent: order.user_agent,
            forterTokenCookie: order.forter_tracking_code
          },
          primaryDeliveryDetails: {
            deliveryType: delivery_type,
            deliveryMethod: delivery_method,
            deliveryPrice: {
              amountUSD: order.shipping_total.to_s
            },
            carrier: shipping_service_carrier
          },
          cartItems: items,
          payment: forter_payments,
          accountOwner: forter_account,
          totalDiscount: forter_discount_codes
        }
      end

      private

        def forter_export_time
          @forter_export_time = Time.new.to_i * 1000
        end

        def delivery_type
          return "DIGITAL" if order.items.all? { |oi| !oi.requires_shipping? }
          return "HYBRID" if order.items.any? { |oi| !oi.requires_shipping? }
          "PHYSICAL"
        end

        def delivery_method
          return "EMAIL" if delivery_type == "DIGITAL"
          shipping_service_name
        end

        def items
          order.items.map do |oi|
            item = Workarea::Storefront::OrderItemViewModel.new(oi)
            {
              basicItemData: {
                name: item.product.name,
                quantity: item.quantity,
                type: item.requires_shipping? ? "TANGIBLE" : "NON_TANGIBLE",
                price: { amountUSD: item.total_value.to_s },
                productId: item.product.id
              }
            }
          end
        end

        def forter_payments
          Forter::Payment.new(payment).to_a
        end

        def forter_account
          Forter::Account.new(order).to_h
        end

        def forter_discount_codes
          return unless order.promo_codes.present?

          # Forter only supports 1 entry in the totalDiscount field.
          code = order.promo_codes.first
          {
            couponCodeUsed: code,
            discountType: "PROMOCODE"
          }
        end

        def payment
          @payment ||= Workarea::Payment.find(order.id)
        end

        def shipping
          @shipping ||= Workarea::Shipping.find_by_order(order.id)
        end

        def shipping_service
          return unless shipping.present? && shipping.shipping_service.present?
          shipping.shipping_service
        end

        def shipping_service_name
          return unless shipping_service.present?
          shipping_service.name
        end

        def shipping_service_carrier
          return unless shipping_service.present?
          shipping_service.carrier
        end

        def primary_recipient_address
          address_obj = if shipping.present?
            shipping.address
          else
            payment.address
          end

          {
            address1: address_obj.street,
            city: address_obj.city,
            country: address_obj.country.alpha2,
            address2: address_obj.street_2,
            zip: address_obj.postal_code,
            region: address_obj.region
          }
        end
    end
  end
end
