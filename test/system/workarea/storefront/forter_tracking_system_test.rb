require 'test_helper'

module Workarea
  module Storefront
    class ForterTrackingSystemTest < Workarea::SystemTest

      def test_forter_tracking_js
        Workarea.with_config do |config|
          config.forter.site_id = "abcdefg"

          visit storefront.root_path

          forter_script = find_by_id('abcdefg', visible: false)

          assert(forter_script.present?)
        end
      end
    end
  end
end
