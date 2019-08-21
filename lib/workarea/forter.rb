require 'workarea'
require 'workarea/storefront'
require 'workarea/admin'

require 'workarea/forter/gateway'
require 'workarea/forter/bogus_gateway'
require 'workarea/forter/decision_response'

require 'workarea/forter/engine'
require 'workarea/forter/version'

module Workarea
  module Forter
    def self.credentials
      (Rails.application.secrets.forter || {}).deep_symbolize_keys
    end

    def self.secret_key
      credentials[:secret_key]
    end

    def self.config
      Workarea.config.forter
    end

    def self.site_id
      config.site_id
    end

    def self.api_version
      config.api_version
    end

    def self.gateway
      if credentials.present?
        Forter::Gateway.new(site_id: site_id, secret_key: secret_key, api_version: api_version)
      else
        Forter::BogusGateway.new
      end
    end

    def self.log_error(error)
      if defined?(::Raven)
        Raven.capture_exception error
      else
        Rails.logger.warn error
      end
    end
  end
end
