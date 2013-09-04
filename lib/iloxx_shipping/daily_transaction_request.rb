module Iloxx
  module Shipping
    class DailyTransactionRequest < Request

      REQUEST_TYPE = :ppvDailyTransactionRequest

      def initialize(attributes = {})
        super(attributes)
        @date = attributes[:date]
        @type = attributes[:type]
      end

      def body(xml)
        xml.tns :TransactionListDate, @date.strftime("%d.%m.%Y")
        xml.tns :TransactionListType, @type
      end
    end
  end
end