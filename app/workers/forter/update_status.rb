module Workarea
  module Forter
    class UpdateStatus
      include Sidekiq::Worker

      def perform(id, status_hash)
        decision = Workarea::Order.find(id).fraud_decision rescue nil

        if decision.blank?
          Rails.logger.warn "No decision record found for #{id} during update status"
          return false
        end

        Workarea::Forter.gateway.update_order_status(id, status_hash)

        decision.external_order_status = status_hash[:updatedStatus]
        decision.save!
      end
    end
  end
end
