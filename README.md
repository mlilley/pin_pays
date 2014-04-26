pin_pays
========

Super simple implementation of the Pin Payments API (pin.com.au) for Ruby and Rails projects.

## Installation

PinPays is available as a gem:

    $ gem install pin_pays

## Setup

Configure your secret-key and whether to use the test or live modes:

```ruby
# config/initializers/pin_pay.rb (for rails)
PinPays.configure do |config|
  config.key  = "your-secret-key" # NB: use the right one for the mode!
  config.mode = :test             # or :live
end
```

TIP: If you're using Rails 4+, I recommend [using your secrets.yml file for the secret key](https://github.com/mlilley/pin_pays/wiki/Using-Rails-4-secrets.yml-file-for-secret-key).

## Usage

PinPays replicates the PinPayments documented API closely.  To understand the requirements for method inputs or return values refer to the [PinPayments documentation](https://pin.net.au/docs/api), then refer to [Responses](#Responses) section below to see how PinPays transforms the API json responses before giving them to you.

Examples:

```ruby
# create a customer
customer = PinPays::Customers:create('moo@cow.com', 'card_token_xyz')
customer[:token] # => 'cust_token_xyz'

# issue a charge
charge = PinPays::Charges:create({ customer_token: customer[:token], email: 'moo@cow.com', description: 'Pants', amount: 4995, remote_ip: '127.0.0.1'})
charge[:token] # => 'charge_token_789'

# pay a refund
refund = PinPays::Refunds.create(charge[:token], 2500)
refund[:token] # => 'refund_token_123'
```

### Cards

##### Create a card ([ref](https://pin.net.au/docs/api/cards))
```ruby
PinPays::Cards.create(card)
```
where ```card``` is a hash of the card details

### Customers

##### Create a customer ([ref](https://pin.net.au/docs/api/customers#post-customers))
```ruby
PinPays::Customers.create(email, card)
```
where ```card``` is either a card_token (of a previously created card) or a hash of card details.

##### List all customers ([ref](https://pin.net.au/docs/api/customers#get-customers))
```ruby
PinPays::Customers.list(page=nil)
```
where ```page``` is the results page number to return (optional)

##### Retrieve details of a specific customer ([ref](https://pin.net.au/docs/api/customers#get-customer))
```ruby
PinPays::Customers.show(customer_token)
```

##### Update a customer's details ([ref](https://pin.net.au/docs/api/customers#put-customer))
```ruby
PinPays::Customers.update(customer_token, options)
```
where ```options``` is a hash of one or more of: ```email:```, ```card_token:```, or ```card:``` (hash of card details).

##### List all charges for a customer ([ref](https://pin.net.au/docs/api/customers#get-customers-charges))
```ruby
PinPays::Customers.charges(customer_token, page=nil)
```
where ```page``` is the results page number to return (optional)

### Charges

##### Create a charge ([ref](https://pin.net.au/docs/api/charges#post-charges))
```ruby
PinPays::Charges.create(options)
```
where ```options``` contains:
- (mandatory) ```email:```, ```description:```, ```amount:```, and ```remote_ip:```
- (mandatory, one of) ```customer_token:```, ```card_token:```, or ```card:``` (hash of card details)
- (optional) ```currency:```, and ```capture:```

##### Capture a charge ([ref](https://pin.net.au/docs/api/charges#put-charges))
```ruby
PinPays::Charges.capture(charge_token)
```

##### List all charges ([ref](https://pin.net.au/docs/api/charges#get-charges))
```ruby
PinPays::Charges.list(page=nil)
```
where ```page``` is the results page number to return (optional)

##### Search for a charge that matches one or more criteria ([ref](https://pin.net.au/docs/api/charges#search-charges))
```ruby
PinPays::Charges.search(criteria)
```
where ```criteria``` is a hash containing one or more criteria to search for.

##### Show details of a specific charge ([ref](https://pin.net.au/docs/api/charges#get-charge))
```ruby
PinPays::Charges.show(charge_token)
```

### Refunds

##### Create a refund ([ref](https://pin.net.au/docs/api/refunds#post-refunds))
```ruby
PinPays::Refunds.create(charge_token, amount=nil)
```
where ```amount``` is the amount in cents of the original charge to refund (optional, otherwise the entire amount).

##### List all refunds for a given charge ([ref](https://pin.net.au/docs/api/refunds#get-refunds))
```ruby
PinPays::Refunds.list(charge_token)
```

### Responses

##### Success Responses

All successful calls return a hash.  Fields of the hash are the same as those documented in PinPayments documentation (with some small convenience tweaks):

Non-paginated style responses have the parent "response" field omitted.  For example, this:

```json
{
  "response": {
    "token": "rf_ERCQy--Ay6o-NKGiUVcKKA",
    "success": null,
    "amount": 400,
    "currency": "USD",
    "charge": "ch_bZ3RhJnIUZ8HhfvH8CCvfA",
    "created_at": "2012-10-27T13:00:00Z",
    "error_message": null,
    "status_message": "Pending"
  }
}
```

becomes this:

```ruby
{
  token: "rf_ERCQy--Ay6o-NKGiUVcKKA",
  success: null,
  amount: 400,
  currency: "USD",
  charge: "ch_bZ3RhJnIUZ8HhfvH8CCvfA",
  created_at: "2012-10-27T13:00:00Z",
  error_message: null,
  status_message: "Pending"
}
```

Note:
- the parent "response" field is omitted
- the hash keys are symbols (not strings)

Additionally, paginated style responses like this:

```json
{
  "response": [
    {
      "token": "ch_lfUYEBK14zotCTykezJkfg",
      "success": true,
      "amount": 400,
      "currency": "USD",
      "description": "test charge",
      "email": "roland@pin.net.au",
      "ip_address": "203.192.1.172",
      "created_at": "2012-06-20T03:10:49Z",
      "status_message": "Success!",
      "error_message": null,
      "card": {
        "token": "card_nytGw7koRg23EEp9NTmz9w",
        "display_number": "XXXX-XXXX-XXXX-0000",
        "expiry_month": 6,
        "expiry_year": 2020,
        "name": "Roland Robot",
        "address_line1": "42 Sevenoaks St",
        "address_line2": null,
        "address_city": "Lathlain",
        "address_postcode": "6454",
        "address_state": "WA",
        "address_country": "Australia",
        "scheme": "master"
      },
      "captured": true,
      "authorisation_expired": false,
      "transfer": null,
      "settlement_currency": "AUD"
    }
  ],
  "pagination": {
    "current": 1,
    "per_page": 25,
    "count": 1
  }
}
```

Become this:

```ruby
{
  items: [
    {
      token: "ch_lfUYEBK14zotCTykezJkfg",
      success: true,
      amount: 400,
      currency: "USD",
      description: "test charge",
      email: "roland@pin.net.au",
      ip_address: "203.192.1.172",
      created_at: "2012-06-20T03:10:49Z",
      status_message: "Success!",
      error_message: null,
      card: {
        token: "card_nytGw7koRg23EEp9NTmz9w",
        display_number: "XXXX-XXXX-XXXX-0000",
        expiry_month: 6,
        expiry_year: 2020,
        name: "Roland Robot",
        address_line1: "42 Sevenoaks St",
        address_line2: null,
        address_city: "Lathlain",
        address_postcode: "6454",
        address_state: "WA",
        address_country: "Australia",
        scheme: "master"
      },
      captured: true,
      authorisation_expired: false,
      transfer: null,
      settlement_currency: "AUD"
    }
  ],
  pages: {
    current: 1,
    per_page: 25,
    count: 1
  }
}
```

Note that:
- the "response" field becomes "items"
- the "pagination" field becomes "pages"

The only exception to the above is the ```PinPays::Refunds.list``` call, which returns only an array of hashes.


##### Error Responses

All error responses result in an Exception of the type ```PinPays::ApiError```.  The exception contains details about the specific error as properties on it:

```ruby
...
rescue PinPays::ApiError => e
  e.error               # -> error code (ie: "insufficient_funds")
  e.error_description   # -> error description (ie: "There are not enough funds available to process the requested amount")
  e.charge_token        # -> of the failed charge (for charge-related api calls)
  e.messages            # -> an array of error messages (useful for displaying to the user on failed form submissions)
  e.raw_response        # -> the raw json api response as a ruby hash
end
...
```

For a list of possible error codes, and example responses see https://pin.net.au/docs/api/test-cards and the remainder of the PinPayments documentation pages.

## License

Released under the [MIT license](http://www.opensource.org/licenses/MIT).
