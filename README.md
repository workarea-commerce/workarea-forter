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


Getting Started
--------------------------------------------------------------------------------

This gem contains a rails engine that must be mounted onto a host Rails application.

To access Workarea gems and source code, you must be an employee of WebLinc or a licensed retailer or partner.

Workarea gems are hosted privately at https://gems.weblinc.com/.
You must have individual or team credentials to install gems from this server. Add your gems server credentials to Bundler:

    bundle config gems.weblinc.com my_username:my_password

Or set the appropriate environment variable in a shell startup file:

    export BUNDLE_GEMS__WEBLINC__COM='my_username:my_password'

Then add the gem to your application's Gemfile specifying the source:

    # ...
    gem 'workarea-forter', source: 'https://gems.weblinc.com'
    # ...

Or use a source block:

    # ...
    source 'https://gems.weblinc.com' do
      gem 'workarea-forter'
    end
    # ...

Update your application's bundle.

    cd path/to/application
    bundle

Workarea Platform Documentation
--------------------------------------------------------------------------------

See [http://developer.weblinc.com](http://developer.weblinc.com) for Workarea platform documentation.

Copyright & Licensing
--------------------------------------------------------------------------------

Copyright WebLinc 2018. All rights reserved.

For licensing, contact sales@workarea.com.
