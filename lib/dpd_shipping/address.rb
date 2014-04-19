module Dpd
  module Shipping
    class Address
      attr_accessor :company, :sex, :name, :street, :zip, :city, :state, :country_code, :email, :phone

      VALID_SEX = [:NoSexCode, :Male, :Female]

      def initialize(attributes = {})
        attributes.each do |key, value|
          setter = :"#{key.to_s}="
          if self.respond_to?(setter)
            self.send(setter, value)
          end
        end
      end

      def company?
        !self.company.blank?
      end

      def sex=(sex)
        raise "Sex must be one of the following: #{VALID_SEX.to_s}" unless VALID_SEX.include? sex
        @sex = sex
      end

      def country_code=(country_code)
        raise "Country code must be an ISO-3166 two digit code" unless country_code.length == 2
        @country_code = country_code
      end

      def append_to_xml(xml)
        xml.tns :ShipAddress do |xml|
          xml.tns :Company, company if company?
          xml.tns :SexCode, sex || :NoSexCode
          xml.tns :Name, name
          xml.tns :Street, street
          xml.tns :ZipCode, zip
          xml.tns :City, city
          xml.tns :State, state || ""
          xml.tns :Country, country_code
          xml.tns :Phone, phone || ""
          xml.tns :Mail, email || ""
        end
      end

    end
  end
end