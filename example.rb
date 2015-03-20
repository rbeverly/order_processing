require 'csv'
require 'geocoder'
require './hash_csv.rb'

ORDER_PATH = ENV['HOME'] + "/Box\ Sync/Tax\ Calculation/orders.csv"
RATE_PATH = ENV['HOME'] + "/Box\ Sync/Tax\ Calculation/county-tax.csv"

orders_csv = CSV.read(ORDER_PATH)
orders = Hash_CSV.convert(orders_csv, true)

rates_csv = CSV.read(RATE_PATH)
rates = Hash_CSV.convert(rates_csv, false)

orders.each { |order| 
  order[:address_string] = [order["Shipping Address1"], 
    order["Shipping City"], 
    order["Shipping State or Province"]].join(' ')
  geo_address = Geocoder.search(order[:address_string])
  order[:county] = geo_address.first.sub_state
  order[:discretionary_tax] = rates[order[:county]]
}
puts orders.first.inspect



