require 'csv'
require 'geocoder'
require './hash_csv.rb'

loaded_csv = CSV.read('./orders.csv')
orders = Hash_CSV.convert(loaded_csv)
orders.each { |order| order[:address_string] = [order["Shipping Address1"], order["Shipping City"], order["Shipping State or Province"]].join(' ') 
  geo_address = Geocoder.search(order[:address_string])
  geo_address[:county] = geo_address.first.sub_state
}
puts geo_address.inspect