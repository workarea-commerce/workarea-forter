module Workarea
  module ForterApiConfig
    def self.included(test)
      super
      test.setup :set_key
      test.teardown :reset_key
    end

    def site_id
      "4d12ac5d794c"
    end

    def set_key
      @_old_secrets = Rails.application.secrets.forter
      @old_site_id = Workarea.config.forter.site_id
      Workarea.config.forter.site_id = site_id
      Rails.application.secrets.forter = {
        secret_key: 'a'
      }
    end

    def reset_key
      Rails.application.secrets.forter = @_old_secrets
      Workarea.config.forter.site_id = @old_site_id
    end
  end
end
