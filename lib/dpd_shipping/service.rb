module Dpd
  module Shipping
    class Service
      attr_reader :cod_amount, :service_type

      def initialize(attributes = {})
        attributes.each do |key, value|
          setter = :"#{key.to_s}="
          if self.respond_to?(setter)
            self.send(setter, value)
          end
        end
      end

      def cod?
        !self.cod_amount.nil? && self.cod_amount > 0
      end

    end
  end
end