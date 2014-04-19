module Dpd
  module Shipping
    class Parcel
      attr_accessor :internal_reference, :customer, :reference, :content, :weight, :service, :address, :track_url

      def initialize(attributes = {})
        attributes.each do |key, value|
          setter = :"#{key.to_s}="
          if self.respond_to?(setter)
            self.send(setter, value)
          end
        end
      end

      def append_to_xml(xml)
        xml.tns(:ppvOrderData) do |xml|
          xml.tns(:PartnerOrderReference, internal_reference || " ")
          xml.tns(:Customer, customer || " ")
          xml.tns(:Reference, reference || " ")
          xml.tns(:Content, content)
          xml.tns(:Weight, weight)
          xml.tns(:ShipService, service.service_type)
          xml.tns(:CODAmount, service.cod_amount || 0)
          address.append_to_xml(xml)
          xml.tns(:TrackURL, track_url || "")
        end
      end

    end
  end
end