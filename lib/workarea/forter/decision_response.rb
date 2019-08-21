module Workarea
  module Forter
    class DecisionResponse
      def initialize(body)
        @body = body
      end

      def success?
        @body["status"] == "success"
      end

      def suspected_fraud?
        @body["action"] == "decline"
      end

      def action
        @body["action"]
      end

      def body_message
        @body["message"]
      end

      def reason_code
        @body["reasonCode"]
      end

      def errors
        @body["errors"]
      end

      def status
        @body["status"]
      end

      def mongoize
        @body
      end

      class << self
        def demongoize(object)
          return nil if object.blank?

          DecisionResponse.new(object)
        end

        def mongoize(object)
          case object
          when DecisionResponse then object.mongoize
          else object
          end
        end

        def evolve(object)
          raise 'querying on an Workarea::Forter::DecisionResponse is unsupported at this time'
        end
      end
    end
  end
end
