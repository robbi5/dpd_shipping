require 'date'
require 'savon'

require 'dpd_shipping/version'
require 'dpd_shipping/address'
require 'dpd_shipping/request'
# requests
require 'dpd_shipping/order_request'
require 'dpd_shipping/daily_transaction_request'
require 'dpd_shipping/parcel'
require 'dpd_shipping/service'
# services
require 'dpd_shipping/service/express'
require 'dpd_shipping/service/normalpaket'
require 'dpd_shipping/service/retoure'
# and the last one:
require 'dpd_shipping/api'