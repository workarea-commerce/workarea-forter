module Workarea
  module Forter
    class Gateway

      attr_reader :options

      def initialize(options = {})
        @options = options
      end

      def create_decision(order_id, order_details)
        body = order_details.to_json

        connection.post do |req|
          req.url "v2/orders/#{order_id}", {}
          req.body = body
        end
      end

      def update_order_status(order_id, order_details)
        body = order_details.to_json

        connection.put do |req|
          req.url "v2/status/#{order_id}", {}
          req.body = body
        end
      end

      private

        def rest_endpoint
          "https://api.forter-secure.com"
        end

        def connection
          headers = {
            "Content-Type" => "application/json",
            "x-forter-siteid" => site_id,
            "api-version" => api_version
          }

          request_timeouts = {
            timeout: Workarea.config.forter[:api_timeout],
            open_timeout: Workarea.config.forter[:open_timeout]
          }

          conn = Faraday.new(url: rest_endpoint, headers: headers, request: request_timeouts)
          conn.basic_auth(secret_key, nil)

          conn
        end

        def api_version
          options[:api_version] || "2.2"
        end

        def secret_key
          options[:secret_key]
        end

        def site_id
          options[:site_id]
        end
    end
  end
end
