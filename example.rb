require 'csv'
require 'geocoder'
require_relative 'hash_csv'
require_relative 'tax_report_csv'
require_relative 'tax_report_html'

ORDER_PATH = ENV['HOME'] + "/Box\ Sync/Tax\ Calculation/orders.csv"
RATE_PATH = ENV['HOME'] + "/Box\ Sync/Tax\ Calculation/county-tax.csv"
OUTPUT_PATH = ENV['HOME'] + "/Box\ Sync/Tax\ Calculation/report"

orders_csv = CSV.read(ORDER_PATH)
orders = HashCSV.convert(orders_csv, true)

rates_csv = CSV.read(RATE_PATH)
rates = HashCSV.convert(rates_csv, false)

orders.each { |order| 
  order[:address_string] = 
    [order["Shipping Address1"].split.map(&:capitalize).join(' '), 
      order["Shipping City"].downcase.capitalize, 
      order["Shipping State or Province"]].join(' ')
  geo_address = Geocoder.search(order[:address_string])
  order[:county] = geo_address.first.sub_state
  order[:discretionary_tax] = rates[order[:county]]
}

TaxReportCSV.write(orders, OUTPUT_PATH + ".csv")
TaxReportHTML.write(orders, OUTPUT_PATH + ".html")

