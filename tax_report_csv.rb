# output to csv format for quickbooks etc

HEADERS = ["OrderNumber", "Date", "ProductName", "Total", "Refunded", "Taxable", "StudentName", "Address", "County", "Discretionary Tax", "Tax"]

class TaxReportCSV
  def self.write(orders, path)
    CSV.open(path, "wb") do |csv|
      csv << HEADERS
      orders.each { |order|
    csv << [
      order["OrderNumber"],
      order["Date"],
      order["ProductName"],
      order["Total"],
      order["Refunded"],
      order["Taxable"],
      order["StudentName"],
      order[:address_string],
      order[:county],
      order[:discretionary_tax],
      order[:tax]
    ]
  }
    end
  end
end
