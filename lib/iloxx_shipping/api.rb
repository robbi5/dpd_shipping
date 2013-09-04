# encoding: UTF-8
module Iloxx
  module Shipping
    class PartnerAuthenticationError < StandardError; end
    class AuthenticationError < StandardError; end
    class ShippingDateError < StandardError; end

    class APIErrorCodes
      PARTNER_AUTH_ERROR = 3 # Ungültige Zugangsdaten (PartnerCredentials).
      AUTH_ERROR = 4 # Ungültige Zugangsdaten oder Nutzung des Services ist nicht freigegeben.
    end

    class API
      DEFAULT_NAMESPACES = {
        "xmlns:iloxx" => "http://iloxx.de/"
      }

      PPVAPI_WSDL = "https://www.iloxx.de/iloxxapi/ppvapi.asmx?WSDL"
      PPVAPI_ENDPOINT = "https://www.iloxx.de/iloxxapi/ppvapi.asmx"

      PPVAPI_TEST_WSDL = "http://qa.www.iloxx.de/iloxxapi/ppvapi.asmx?WSDL"
      PPVAPI_TEST_ENDPOINT = "http://qa.www.iloxx.de/iloxxapi/ppvapi.asmx"

      API_VERSION = 102

      def initialize(config, options = {})
        raise "User ID must be specified" if config[:user].nil?
        raise "User Token must be specified" if config[:token].nil?

        if options[:test]
          wsdl_url = PPVAPI_TEST_WSDL
          endpoint = PPVAPI_TEST_ENDPOINT
        else
          wsdl_url = PPVAPI_WSDL
          endpoint = PPVAPI_ENDPOINT
        end

        @user = config[:user]
        @token = config[:token]
        @partner_name = config[:partner_name] || 'iloxx.24'
        @partner_key = config[:partner_key] || '554F346F592B42757131367A64477A7A676362767A413D3D'

        @options = options
        @client = ::Savon::Client.new do |sc|
          sc.wsdl wsdl_url
          sc.endpoint endpoint
          sc.namespace DEFAULT_NAMESPACES['xmlns:iloxx']
          sc.soap_version 2
          sc.filters [:LabelPDFStream, :UserToken]
        end
      end

      def add_order(parcels, date = nil)
        shipping_date = date || Date.today

        if shipping_date > Date.today + 7
          raise ShippingDateError.new('Invalid shipping date. Min: today, max: +7 days')
        end

        if !parcels.is_a? Array
          parcels = [parcels]
        end
        parcels.each do |p|
          p.internal_reference = parcels.index p
        end

        request = OrderRequest.new(
          :version => API_VERSION,
          :auth => auth_hash,
          :shipping_date => shipping_date,
          :parcels => parcels
        )
        response = @client.call(:ppv_add_order, message: request.build!)

        result = response.body[:ppv_add_order_response][:ppv_add_order_result]
        if result[:ack] == 'Success'
          shipments = []
          if !result[:response_data_array].is_a? Array
            result[:response_data_array] = [result[:response_data_array][:response_data]]
          end
          result[:response_data_array].each { |rdata| shipments << rdata }
          {
            :label_data => result[:label_pdf_stream],
            :shipments => shipments
          }
        else
          handle_errors result
        end
      end

      def get_daily_transaction_list(date = nil)
        shipping_date = date || Date.today

        request = DailyTransactionRequest.new(
          :version => API_VERSION,
          :auth => auth_hash,
          :date => shipping_date,
          :type => :DPD
        )

        response = @client.call(:ppv_get_daily_transaction_list, message: request.build!)
        result = response.body[:ppv_get_daily_transaction_list_response][:ppv_add_order_result]
        if result[:DailyTransactionResponse] == 'Success'
          {
            :transaction_list => result[:transaction_list_pdf_stream]
          }
        else
          handle_errors result
        end
      end

      protected

      def auth_hash
        {
          :partner => {
            :name => @partner_name,
            :key => @partner_key
          },
          :user => {
            :id => @user,
            :token => @token
          }
        }
      end

      def handle_errors(result)
        errors = result[:error_data_array][:error_data]
        errors = [errors] unless errors.is_a? Array

        errors.each do |err|
          id = err[:error_id].to_i
          msg = " " + (err[:error_msg] || "")
          case id
          when APIErrorCodes::PARTNER_AUTH_ERROR
            raise PartnerAuthenticationError.new('Failed to authenticate partner.' + msg)
          when APIErrorCodes::AUTH_ERROR
            raise AuthenticationError.new('Failed to authenticate.' + msg)
          else
            raise "Iloxx API call failed: ##{id}: #{msg}"
          end
        end
      end
    end
  end
end