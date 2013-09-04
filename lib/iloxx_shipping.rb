require 'date'
require 'savon'

require 'iloxx_shipping/version'
require 'iloxx_shipping/address'
require 'iloxx_shipping/request'
# requests
require 'iloxx_shipping/order_request'
require 'iloxx_shipping/daily_transaction_request'
require 'iloxx_shipping/parcel'
require 'iloxx_shipping/service'
# services
require 'iloxx_shipping/service/express'
require 'iloxx_shipping/service/normalpaket'
require 'iloxx_shipping/service/retoure'
# and the last one:
require 'iloxx_shipping/api'