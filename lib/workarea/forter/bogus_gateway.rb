module Workarea
  module Forter
    class BogusGateway
      attr_reader :options

      def initialize(options = {})
        @options = options
      end

      def create_decision(order_id, hsh = {})
        response_json = if hsh[:accountOwner][:email] == "decline@workarea.com"
          response_body(order_id, "decline")
        elsif hsh[:accountOwner][:email] == "notreviewed@workarea.com"
          response_body(order_id, "not reviewed")
        elsif hsh[:accountOwner][:email] == "error@workarea.com"
          error_body(order_id)
        else
          response_body(order_id, "approve")
        end

        response = Faraday.new do |builder|
          builder.adapter :test do |stub|
            stub.get('/rest/bogus.json') { |env| [ 200, {}, response_json ] }
          end
        end
        response.get('/rest/bogus.json')
      end

      def method_missing(method, *args)
        generic_response
      end

      private

        def generic_response
          response = Faraday.new do |builder|
            builder.adapter :test do |stub|
              stub.get('/rest/bogus.json') { |env| [ 200, {}, nil ] }
            end
          end
          response.get('/rest/bogus.json')
        end

        def response_body(id, action)
          {
            status: "success",
            transaction: "#{id}",
            action: "#{action}",
            message: "Transaction #{id}"
          }.to_json
        end

        def error_body(id)
          {
            status: "failure",
            action: "",
            errors: [{ "path" => "#/payment/", "message" => "Forced Gateway Error" }]
          }.to_json
        end
    end
  end
end
