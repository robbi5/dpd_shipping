# encoding: UTF-8
require 'spec_helper'

describe Iloxx::Shipping::Parcel do

  before(:all) do
    @receiver = Iloxx::Shipping::Address.new({
      :name => "Lilly Lox",
      :street => "Gutenstetter Str. 8b",
      :zip => "90449",
      :city => "Nürnberg",
      :country_code => "DE"
    })
  end

  it "should generate simple xml for a simple parcel" do
    parcel = Iloxx::Shipping::Parcel.new(
      weight: 1.25,
      content: "Stones",
      address: @receiver,
      service: Iloxx::Shipping::NormalpaketService.new,
      reference: "Order #1234",
    )

    xml = wrap_in_xml_tree do |xml|
      parcel.append_to_xml xml
    end

    xml.should eq(f :parcel, :simple)
  end

end