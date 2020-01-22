Workarea Forter 1.3.2 (2020-01-21)
--------------------------------------------------------------------------------

*   Fix Tests for 2020

    Update all tests so that they no longer depend on the year 2020 as an
    expiration year. Instead, use the  method provided by Workarea.

    FORTER-2
    Tom Scott



Workarea Forter 1.3.1 (2020-01-07)
--------------------------------------------------------------------------------

*   Only send payment tenders to Forter that have transactions

    FORTER-1
    Jeff Yucis



Workarea Forter 1.3.0 (2019-11-26)
--------------------------------------------------------------------------------

*   V3.5 compatability updates

    Update to make the plugin compatible with the 3.5 fraud
    framework. Moves the decision to post auth.
    Jeff Yucis



Workarea Forter 1.2.4 (2019-10-16)
--------------------------------------------------------------------------------

*   Set default Forter API version to 2.3

    API version 2.3 allows for the general payment option, which
    allows users to pass payment types that are not explicitly supported
    by Forter.
    Jeff Yucis

*   Add additional data to forter credit card tender data.

    Adds the gateway name and transaction ID to the credit card
    information sent to forter when making a decision.
    Jeff Yucis

*   Update README

    Matt Duffy



Workarea Forter 1.2.3 (2019-09-17)
--------------------------------------------------------------------------------

* Fix integration test name

Workarea Forter 1.2.2 (2019-08-21)
--------------------------------------------------------------------------------

*   Open Source!
 
 
 
Workarea Forter 1.2.1 (2019-08-06)
--------------------------------------------------------------------------------

*   Add API version to configuration.

    FORTER-15
    Jeff Yucis

*   Set the BIN for saved cards added from my account section

    FORTER-17
    Jeff Yucis



Workarea Forter 1.2.0 (2019-04-30)
--------------------------------------------------------------------------------

*   Add support for checkout.com payment processor

    Extracts the payment processor response code used by forter when
    evaluating for fraud.

    FORTER-13
    Jeff Yucis



Workarea Forter 1.1.0 (2019-03-19)
--------------------------------------------------------------------------------

*   * Remove checkout controller decorator, user agent functionality is part of Workarea now

    FORTER-12
    Jake Beresford

*   Update for v3.4

    * Update CI scripts
    * Remove user_agent decoration from order.rb, this is part of Workarea::Order as of v3.4
    * Update gemspec dependency for workarea to >= 3.4

    FORTER-12
    Jake Beresford



Workarea Forter 1.0.0 (2019-03-05)
--------------------------------------------------------------------------------

*   Forter fraud protection integration. Automatic decision at checkout with no intervention required from admins.

    Jeff Yucis



