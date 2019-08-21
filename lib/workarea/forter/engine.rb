module Workarea
  module Forter
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::Forter
    end
  end
end
