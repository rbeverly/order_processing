# output to csv format for quickbooks etc

HEADERS = ["Order Number", "Name", "Address", "County", "Discretionary Tax"]

class Tax_Report_CSV
  def self.write(orders, path)
    CSV.open(path, "wb") do |csv|
      csv << HEADERS
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
  end
end

