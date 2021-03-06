require 'csv'
require 'geocoder'
require_relative 'hash_csv'
require_relative 'tax_report_csv'
require_relative 'tax_report_html'
# require 'pry'

#TODO: Price of each order and total tax

ORDER_PATH = ENV['HOME'] + "/Box\ Sync/Tax\ Calculation/export.csv"
RATE_PATH = ENV['HOME'] + "/Box\ Sync/Tax\ Calculation/county-tax.csv"
OUTPUT_PATH = ENV['HOME'] + "/Box\ Sync/Tax\ Calculation/report"

key_file = File.new(ENV['HOME'] + "/Box\ Sync/Tax\ Calculation/google_api.txt", "r")
api_key = key_file.readlines[0]
key_file.close
# puts "Using key: " + api_key

Geocoder.configure(
  :lookup => :google,
  :api_key => api_key,
  :use_https => true
)

orders_csv = CSV.read(ORDER_PATH)
orders = HashCSV.convert(orders_csv, true)

rates_csv = CSV.read(RATE_PATH)
rates = HashCSV.convert(rates_csv, false)

throttle = 0
queries = 0
print "Query: "
CSV.open(OUTPUT_PATH + ".csv", "wb") do |csv|
  orders.each { |order|

    if order["PostalCode"].nil? || (order["State"] != "FL")
      order[:county] = "unknown"
      order[:discretionary_tax] = "unknown"
      order[:address_string] = "No address found"
      next
    end

    order[:address_string] =
      [order["Address"].split.map(&:capitalize).join(' '),
        order["City"].downcase.capitalize + ",",
        order["State"],
        order["PostalCode"]].join(' ')

    queries += 1
    print "#{queries}.. "

    if (geo_address = Geocoder.search(order[:address_string]))
      puts "Done geocoding... I think"
    else
      puts "Geocode error."
    end
    # binding.pry
    if geo_address.first.nil?
      order[:county] = "unknown"
      order[:discretionary_tax] = "unknown"
    else
      if geo_address.first.sub_state.nil?
        order[:county] = "unknown"
        order[:discretionary_tax] = "unknown"
        order[:tax] = "0"
      else
        order[:county] = geo_address.first.sub_state
        order[:discretionary_tax] = rates[order[:county]]
        order[:tax] = (6.0 + order[:discretionary_tax].to_f).to_s
      end
    end
    # binding.pry
    order[:county] || order[:county] = "unknown"
    order[:discretionary_tax] || order[:discretionary_tax] = "unknown"

    throttle += 1
    if throttle >= 5
      sleep 1
      throttle = 0
    end
  }
end

begin
  TaxReportCSV.write(orders, OUTPUT_PATH + ".csv")
rescue
  puts "Did not write CSV, sorry."
end

begin
  TaxReportHTML.write(orders, OUTPUT_PATH + ".html")
rescue
  puts "Did not write HTML, sorry."
end
