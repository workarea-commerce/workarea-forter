module Workarea
  module Forter
    class Decision
      include ApplicationDocument

      embeds_many :responses, class_name: 'Workarea::Forter::Response'
      field :external_order_status, type: String, default: "PROCESSING"

      index(created_at: -1)

      # the last response returned from the forter service.
      def response
        return if responses.empty?
        responses.sort_by { |r| r.created_at.to_i }.last.decision_response
      end
    end
  end
end
