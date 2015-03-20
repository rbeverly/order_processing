# Turns a csv into a basic hash

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

class Array
  def odds
    self.values_at(* self.each_index.select {|i| i.odd?})
  end
  def evens
    self.values_at(* self.each_index.select {|i| i.even?})
  end
end