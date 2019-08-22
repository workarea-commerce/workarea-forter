source 'https://rubygems.org'
git_source(:github) { |repo| "git@github.com:#{repo}.git" }

gemspec

gem 'workarea'
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
    gem 'workarea-checkoutdotcom'
  end
end
