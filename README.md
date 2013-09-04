# Iloxx::Shipping

[![Gem Version](https://badge.fury.io/rb/iloxx_shipping.png)](http://badge.fury.io/rb/iloxx_shipping) [![Build Status](https://travis-ci.org/robbi5/iloxx_shipping.png)](https://travis-ci.org/robbi5/iloxx_shipping)

This gem is a wrapper around the SOAP-based API provided by [iloxx](http://iloxx.de). It allows you to build and send a shipment request and return a shipping label and the parcel numbers.

## Installation

Add this line to your application's Gemfile:

    gem 'iloxx_shipping'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install iloxx_shipping

## Usage

1. Create a new receiver address:

        receiver = Iloxx::Shipping::Address.new({
          :name => "Lilly Lox",
          :street => "Gutenstetter Str. 8b",
          :zip => "90449",
          :city => "Nürnberg",
          :country_code => "DE"
        })

2. Create a new parcel

        parcel = Iloxx::Shipping::Parcel.new(
          weight: 1.25,
          content: "Stones",
          address: receiver,
          service: Iloxx::Shipping::NormalpaketService.new,
          # ^- or use ExpressService or RetoureService (with parameters) instead
          reference: "Order #1234",
        )

3. Submit your parcel

        config = {
          user: "Your Iloxx User ID",
          token: "Your Iloxx User Token",
        }
        api = Iloxx::Shipping::API.new(config, {
          test: true # If test is set, all API calls go against the test system
        })
        shipment_date = Date.today
        result = api.add_order(parcel, shipment_date)


4. Receive the parcel number and label pdf

        result[:shipments].each do |shipment|
          p shipment[:parcel_number]
        end

        # base64 encoded label.pdf in result[:label_data] - lets save it to disk:

        f = File.open('label.pdf', 'w')
        begin
          f.write Base64.decode64(result[:label_data])
        ensure
          f.close unless f.nil?
        end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks

* iloxx AG for providing the documentation for their SOAP API
* [savon](http://github.com/savonrb) for a nice soap abstraction library
