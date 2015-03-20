require 'csv'
require 'geocoder'
require './hash_csv.rb'

ORDER_PATH = ENV['HOME'] + "/Box\ Sync/Tax\ Calculation/orders.csv"
RATE_PATH = ENV['HOME'] + "/Box\ Sync/Tax\ Calculation/county-tax.csv"
OUTPUT_PATH = ENV['HOME'] + "/Box\ Sync/Tax\ Calculation/report.csv"

orders_csv = CSV.read(ORDER_PATH)
orders = Hash_CSV.convert(orders_csv, true)

rates_csv = CSV.read(RATE_PATH)
rates = Hash_CSV.convert(rates_csv, false)

orders.each { |order| 
  order[:address_string] = 
    [order["Shipping Address1"].split.map(&:capitalize).join(' '), 
      order["Shipping City"].downcase.capitalize, 
      order["Shipping State or Province"]].join(' ')
  geo_address = Geocoder.search(order[:address_string])
  order[:county] = geo_address.first.sub_state
  order[:discretionary_tax] = rates[order[:county]]
}

# puts orders.first.inspect

CSV.open(OUTPUT_PATH, "wb") do |csv|
  csv << ["Order Number", "Name", "Address", "County", "Discretionary Tax"]
  orders.each { |order| 
    csv << [
      order["Order number"], 
      order["Billing First Name"].downcase.capitalize + 
        " " + order["Billing Last Name"].downcase.capitalize,
      order[:address_string],
      order[:county],
      order[:discretionary_tax]
    ]
  }
end

