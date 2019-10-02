Workarea Forter
================================================================================

Forter fraud protection for the Workarea platform that offers guarantees against charge-backs for eligible transactions.

This solution currently works for a pre-authorization model of payment, meaning that funds are authorized at checkout then captured at a later date, usually when the product ships.

Payments use the following flow:
1. A user enters their payment in checkout.
2. The payment is authorized.
3. An API call is made to Forter.
  + On approval or no-decision the order is placed as usual.
  + On decline the authorized payments are voided and a message is displayed to the user.

This plugin is compatible with following Workarea supported payment types:
+ Credit Cards
+ Paypal
+ Gift cards
+ Store credit

Payment types not in this list will still function but are not eligible for fraud protection.

Getting Started
--------------------------------------------------------------------------------

Add the gem to your application's Gemfile:

```ruby
# ...
gem 'workarea-forter'
# ...
```

Update your application's bundle.

```bash
cd path/to/application
bundle
```

Configuration
--------------------------------------------------------------------------------
Add the secret key to your secrets file:

```
forter:
  secret_key: XXXXXXXX
```

Add the site ID to an initializer file in your host app:

```ruby
  Workarea.config.forter.site_id = nil
```

You can specify which version of the API via configuration:

```ruby
  Workarea.config.forter.api_version = "2.4"
```

If no API version is configured the default of **2.2** will be used.

Setting a configuration value for ```credit_card_gateway_name``` value will improve the decision accuracy. This is the name of the credit card processor used by the host application.

```ruby
  Workarea.config.forter.credit_card_gateway_name = "Stripe"
```

Implementation Notes
--------------------------------------------------------------------------------
**Verifcation Data**

Forter relies on verification data returned from the credit processor when validating credit card transactions. This data can vary by credit card processor.

Be sure to test that the following data is sent in the **verificationResults**  hash sent with each credit card:
```
  {
      "avsFullResult": "",
      "cvvResult": "",
      "avsNameResult": "",
      "authorizationCode": "",
      "processorResponseCode": "",
      "processorResponseText": ""
  }
```
**Rolling Back Fraud Transactions**

Credit card authorizations are voided when a transaction is deemed to be fraudulent. The void action relies on the #cancel! method implemented on each tenders authorization class. It is very important to implement and test this method when creating a new payment type.

Workarea Commerce Documentation
--------------------------------------------------------------------------------

See [https://developer.workarea.com](https://developer.workarea.com) for Workarea Commerce documentation.

License
--------------------------------------------------------------------------------

Workarea Forter is released under the [Business Software License](LICENSE)
