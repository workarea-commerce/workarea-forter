source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

gem 'workarea', github: 'workarea-commerce/workarea', branch: 'v3.4-stable'

gem 'byebug'
group :test do
  gem 'simplecov', require: false

  case ENV['CC_PROCESSOR']
  when 'braintree'
    gem 'workarea-braintree'
  when 'moneris'
    gem 'workarea-moneris'
  when 'authorize_cim'
    gem 'workarea-authorize_cim'
  when 'payflow_pro'
    gem 'workarea-payflow_pro'
  when 'cyber_source'
    gem 'workarea-cyber_source'
  when 'checkoutdotcom'
    gem 'workarea-checkoutdotcom', source: 'https://gems.weblinc.com'
  end
end
