Workarea.configure do |config|
  config.order_status_calculators.insert(0, 'Workarea::Order::Status::SuspectedFraud')
  config.payment_status_calculators.insert(0, 'Workarea::Payment::Status::SuspectedFraud')

  config.forter = ActiveSupport::Configurable::Configuration.new
  config.forter.site_id = nil

  config.forter.api_version = "2.3"

  config.forter.api_timeout = 2
  config.forter.open_timeout = 2

  config.forter.credit_card_gateway_name = nil # name of payment gateway used, ie. Stripe

  config.forter.response_code = {
    'ActiveMerchant::Billing::StripeGateway' => -> (transaction) { transaction.params['failure_code'] },
    'ActiveMerchant::Billing::BraintreeBlueGateway' => -> (transaction) { transaction.response.params["braintree_transaction"]["processor_response_code"] },
    'ActiveMerchant::Billing::MonerisGateway' => -> (transaction) { transaction.response.params["response_code"] },
    'ActiveMerchant::Billing::AuthorizeNetCimGateway' => -> (transaction) { transaction.response.params["direct_response"]["response_code"] },
    'ActiveMerchant::Billing::PayflowGateway' => -> (transaction) { transaction.response.params["result"] },
    'ActiveMerchant::Billing::CyberSourceGateway' => -> (transaction) { transaction.response.params["reasonCode"] },
    'ActiveMerchant::Billing::CheckoutV2Gateway' => -> (transaction) { transaction.response.params["responseCode"] || transaction.response.params["response_code"]  }
  }
end
