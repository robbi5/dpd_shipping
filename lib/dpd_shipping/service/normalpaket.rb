module Dpd
  module Shipping
    class NormalpaketService < Service

      attr_reader :flex

      def cod=(cod)
        raise "COD and Flex cannot be combined" if flex?
        @cod_amount = cod
      end

      def flex=(flex)
        raise "Flex and COD cannot be combined" if cod?
        @flex = flex
      end

      def flex?
        !!@flex
      end

      def service_type
        "dpdNormalpaket" + (cod? ? 'COD' : '') + (flex? ? 'Flex' : '')
      end

    end
  end
end