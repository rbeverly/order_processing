# Turns a csv into some reasonable sortofa hash

class Hash_CSV
  # Pass in a CSV, ie: CSV.read('file/path')
  def self.convert(c, headers)
    if (headers == true)
      c_copy = c.dup
      keys = c_copy[0]
      values = c_copy.delete_at(0)
      c_copy.map { |item| Hash[keys.zip(item)] }
    else
      Hash[*c.dup.flatten]
    end
  end
end