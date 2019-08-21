source 'https://rubygems.org'

gemspec

gem 'workarea', source: 'https://gems.weblinc.com'
gem 'byebug'
group :test do
  gem 'simplecov', require: false

  case ENV['CC_PROCESSOR']
  when 'braintree'
    gem 'workarea-braintree', source: 'https://gems.weblinc.com'
  when 'moneris'
    gem 'workarea-moneris', source: 'https://gems.weblinc.com'
  when 'authorize_cim'
    gem 'workarea-authorize_cim', source: 'https://gems.weblinc.com'
  when 'payflow_pro'
    gem 'workarea-payflow_pro', source: 'https://gems.weblinc.com'
  when 'cyber_source'
    gem 'workarea-cyber_source', source: 'https://gems.weblinc.com'
  when 'checkoutdotcom'
    gem 'workarea-checkoutdotcom', source: 'https://gems.weblinc.com'
  end
end
