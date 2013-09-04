# encoding: UTF-8
require 'spec_helper'

describe Iloxx::Shipping::Address do

  it "should generate simple xml for a simple address" do
    receiver = Iloxx::Shipping::Address.new({
      :name => "Lilly Lox",
      :street => "Gutenstetter Str. 8b",
      :zip => "90449",
      :city => "Nürnberg",
      :country_code => "DE"
    })

    xml = wrap_in_xml_tree do |xml|
      receiver.append_to_xml xml
    end

    xml.should eq(f :address, :simple)
  end

  it "should raise an error if the country is not in ISO-3166 format" do
    expect {
      receiver = Iloxx::Shipping::Address.new({
        :country_code => "TEST"
      })
    }.to raise_error
  end

  it "should include a company xml tag if company is set" do
    receiver = Iloxx::Shipping::Address.new({
      :company => "Testcompany",
      :name => "Lilly Lox",
      :street => "Gutenstetter Str. 8b",
      :zip => "90449",
      :city => "Nürnberg",
      :country_code => "DE"
    })

    xml = wrap_in_xml_tree do |xml|
      receiver.append_to_xml xml
    end

    xml.should eq(f :address, :with_company)
  end

  it "should raise an error if sex is not in NoSexCode, Female, Male" do
    expect {
      Iloxx::Shipping::Address.new({ :sex => "TEST" })
    }.to raise_error
  end
end