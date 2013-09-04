# encoding: UTF-8
require 'spec_helper'
require 'date'

describe Iloxx::Shipping::OrderRequest do

  before(:all) do
    @receiver = Iloxx::Shipping::Address.new(
      name: "Lilly Lox",
      street: "Gutenstetter Str. 8b",
      zip: "90449",
      city: "Nürnberg",
      country_code: "DE"
    )

    @parcel = Iloxx::Shipping::Parcel.new(
      weight: 1.25,
      content: "Stones",
      address: @receiver,
      service: Iloxx::Shipping::NormalpaketService.new,
      reference: "Order #1234",
    )
  end

  it "should generate xml for a normal request" do
    request = Iloxx::Shipping::OrderRequest.new(
      :version => Iloxx::Shipping::API::API_VERSION,
      :auth => {
        :partner => {
          :name => "testpartner",
          :key => "testpartner-KEY"
        },
        :user => {
          :id => 404,
          :token => "testuser-TOKEN"
        }
      },
      :shipping_date => Date.parse("2012-05-15"),
      :parcels => [@parcel]
    )

    xml = request.build!
    xml.should eq(f :order_request, :simple)
  end

end