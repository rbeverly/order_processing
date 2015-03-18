# Turns a csv into a basic hash

class Hash_CSV
  # Pass in a CSV, ie: CSV.read('file/path')
  def self.convert(c)
    keys = c[0]
    c.delete_at(0)
    c.map { |item| Hash[keys.zip(item)]}
  end
end