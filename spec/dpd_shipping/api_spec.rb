# encoding: UTF-8
require 'spec_helper'

describe Dpd::Shipping do
  include Savon::SpecHelper

  before(:all) {
    @receiver = Dpd::Shipping::Address.new({
      :name => "Lilly Lox",
      :street => "Gutenstetter Str. 8b",
      :zip => "90449",
      :city => "Nürnberg",
      :country_code => "DE"
    })

    @parcel = Dpd::Shipping::Parcel.new(
      weight: 1.25,
      content: "Stones",
      address: @receiver,
      service: Dpd::Shipping::NormalpaketService.new,
      reference: "Order #1234",
    )

    @shipment_date = Date.parse("2012-05-15")

    savon.mock!
  }
  after(:all)  { savon.unmock! }

  it "should send a successful soap request" do
    stub_wsdl
    savon.expects(:ppv_add_order).with(message: f(:api, :request)).returns(f :api, :response)

    config = {
      user: 404,
      token: "testuser-token"
    }
    api = Dpd::Shipping::API.new(config, { test: true })
    result = api.add_order(@parcel, @shipment_date)

    result[:shipments][0][:partner_order_reference].should eq "0"
    result[:shipments][0][:parcel_number].should eq "09445306577674"
  end

  it "should throw a AuthenticationError" do
    stub_wsdl
    savon.expects(:ppv_add_order).with(message: f(:api, :bad_auth_request)).returns(f :api, :bad_auth_response)

    config = {
      user: 404,
      token: "testuser-token"
    }
    api = Dpd::Shipping::API.new(config, { test: true })
    expect {
      api.add_order(@parcel, @shipment_date)
    }.to raise_error(Dpd::Shipping::AuthenticationError)
  end

  it "should throw a ShippingDateError if the shipping date is too far in the future" do
    stub_wsdl
    config = {
      user: 404,
      token: "testuser-token"
    }
    api = Dpd::Shipping::API.new(config, { test: true })
    future_date = Date.today + 15
    expect {
      api.add_order(@parcel, future_date)
    }.to raise_error(Dpd::Shipping::ShippingDateError)
  end
end