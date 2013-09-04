module Iloxx
  module Shipping
    class RetoureService < Service
      attr_accessor :pickup

      def pickup?
        !!@pickup
      end

      def service_type
        if pickup?
          "dpdRetourePickup"
        else
          "dpdShopRetoure"
        end
      end

    end
  end
end