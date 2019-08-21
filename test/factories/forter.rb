module Workarea
  module Factories
    module Forter
      Factories.add self

      def create_placed_forter_order(overrides = {}, options = {})
        attributes = {
          id: '1234',
          email: 'tester@workarea.com',
          placed_at: Time.current,
          ip_address: '127.0.0.1',
          user_agent: 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0 Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0.',
          forter_tracking_code: '123ABC'
        }.merge(overrides)

        shipping_service = create_shipping_service
        sku = 'SKU'
        create_product(variants: [{ sku: sku, regular: 5.to_m }])
        details = OrderItemDetails.find(sku)
        order = Workarea::Order.new(attributes)
        item = { sku: sku, quantity: 2 }.merge(details.to_h)

        order.add_item(item)

        checkout = Checkout.new(order)
        checkout.update(
          shipping_address: {
            first_name: 'Ben',
            last_name: 'Crouse',
            street: '22 S. 3rd St.',
            street_2: 'Second Floor',
            city: 'Philadelphia',
            region: 'PA',
            postal_code: '19106',
            country: 'US'
          },
          billing_address: {
            first_name: 'Ben',
            last_name: 'Crouse',
            street: '12 N. 3rd St.',
            street_2: 'thrid floor',
            city: 'Philadelphia',
            region: 'PA',
            postal_code: '19106',
            country: 'US'
          },
          shipping_service: shipping_service.name,
        )

        if options[:store_credit_amount].present?
          checkout.payment_profile.store_credit = options[:store_credit_amount]
          checkout.payment.build_store_credit
        end

        checkout.update(
          payment: 'new_card',
          credit_card: {
            number: '4111111111111111',
            month: '1',
            year: Time.current.year + 1,
            cvv: '999'
            }
        )

        checkout.place_order

        forced_attrs = overrides.slice(:placed_at, :update_at, :total_price)
        order.update_attributes!(forced_attrs)
        order
      end

      def create_purchasable_checkout(options = {})
        product = create_product(variants: [{ sku: 'SKU', regular: 5.to_m }])

        order_attributes = {
          email: 'bcrouse-new@workarea.com'
        }.merge(options[:order] || {})

        order = Workarea::Order.new(order_attributes).tap do |o|
          o.add_item(product_id: product.id, sku: 'SKU', quantity: 2)
        end

        shipping_address = {
          first_name: 'Ben',
          last_name: 'Crouse',
          street: '22 S. 3rd St.',
          street_2: 'Second Floor',
          city: 'Philadelphia',
          region: 'PA',
          postal_code: '19106',
          country: 'US'
        }.merge(options[:shipping_address] || {})

        billing_address = {
          first_name: 'Ben',
          last_name: 'Crouse',
          street: '22 S. 3rd St.',
          street_2: 'Second Floor',
          city: 'Philadelphia',
          region: 'PA',
          postal_code: '19106',
          country: 'US'
        }.merge(options[:billing_address] || {})

        credit_card = {
          number: '4111_1111_1111_1111',
          month: '01',
          year: Time.current.year + 1,
          cvv: '999'
        }.merge(options[:credit_card] || {})

        shipping_service = options[:shipping_service].presence ||
                            create_shipping_service.name

        order.items.each do |item|
          item.update_attributes!(OrderItemDetails.find!(item.sku).to_h)
        end

        checkout = Checkout.new(order)
        checkout.update(
          shipping_address: shipping_address,
          billing_address: billing_address,
          shipping_service: shipping_service,
          payment: 'new_card',
          credit_card: credit_card
        )

        checkout
      end
    end
  end
end
