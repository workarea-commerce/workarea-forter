module Workarea
  module Forter
    class Account
      attr_reader :order, :options

      def initialize(order, options = {})
        @order = order
        @options = options
      end

      # @return Hash
      def to_h
        return guest_account unless order.user_id.present?

        user_account
      end

      private

        def user_account
          user = Workarea::User.find(order.user_id)
            {
              firstName: user.first_name,
              lastName: user.last_name,
              email: user.email,
              accountId: user.id.to_s,
              created: user.created_at.to_i,
              lastLoginIP: user.ip_address
            }
        end

        def guest_account
          payment = Workarea::Payment.find(order.id)
          {
            firstName: payment.address.first_name,
            lastName: payment.address.last_name,
            email: order.email
          }
        end
    end
  end
end
