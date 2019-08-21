module Workarea
  module Forter
    class Response
      include Workarea::ApplicationDocument

      field :decision_response, type: Workarea::Forter::DecisionResponse
      field :timed_out, type: Boolean, default: false
      field :error, type: String

      def fraud_decision_action
        decision_response&.action.presence || I18n.t('workarea.admin.orders.forter.decision_error')
      end
    end
  end
end
