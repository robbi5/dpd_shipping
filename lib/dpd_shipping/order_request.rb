module Dpd
  module Shipping
    class OrderRequest < Request

      REQUEST_TYPE = :ppvOrderRequest

      def initialize(attributes = {})
        super(attributes)
        @shipping_date = attributes[:shipping_date]
        @parcels = attributes[:parcels]
      end

      def body(xml)
        xml.tns :OrderAction, "addOrder"
        xml.tns :ServiceSettings do |xml|
          xml.tns :ErrorLanguage, "German" # TODO: make configurable
          xml.tns :CountrySettings, "ISO3166"
          xml.tns :ZipCodeSetting, "ZipCodeAsSingleValue"
        end
        xml.tns :OrderLabel do |xml|
          xml.tns :LabelSize, "MultiLabel_A4" # TODO: make configurable
          xml.tns :LabelStartPosition, "UpperLeft"
        end
        xml.tns :ShipDate, @shipping_date.strftime("%d.%m.%Y")
        xml.tns :ppvOrderDataArray do |xml|
          @parcels.each do |parcel|
            parcel.append_to_xml(xml)
          end
        end
      end
    end
  end
end