require 'workarea/testing/teaspoon'

Teaspoon.configure do |config|
  config.root = Workarea::Forter::Engine.root
  Workarea::Teaspoon.apply(config)
end
