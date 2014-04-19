module Dpd
  module Shipping
    class Request

      def initialize(attributes = {})
        @version = attributes[:version]
        @auth = attributes[:auth]
      end

      def body
        # void
      end

      def build!
        builder = Builder::XmlMarkup.new
        builder.tns self.class::REQUEST_TYPE do |xml|
          xml.tns :Version, @version
          add_auth_to_xml(xml)
          body(xml)
        end

        builder.target!
      end

      protected

      def add_auth_to_xml(xml)
        xml.tns :PartnerCredentials do |pc|
          pc.tns :PartnerName, @auth[:partner][:name]
          pc.tns :PartnerKey, @auth[:partner][:key]
        end
        xml.tns :UserCredentials do |uc|
          uc.tns :UserID, @auth[:user][:id]
          uc.tns :UserToken, @auth[:user][:token]
        end
      end

    end
  end
end