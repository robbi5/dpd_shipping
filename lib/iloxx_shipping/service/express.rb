module Iloxx
  module Shipping
    class ExpressService < Service
      attr_reader :time

      VALID_TIMES = [
        10,
        12,
        18,
        "Samstag12"
      ]

      def time=(time)
        raise "Time is not valid, possible values: #{VALID_TIMES.to_s}" unless VALID_TIMES.include? time
        @time = time
      end

      def service_type
        "dpdExpress" + @time + (cod? ? 'COD' : '')
      end

    end
  end
end