# use a haml template to render html report page.
# engine = Haml::Engine.new("%p Haml code!")
# engine.render #=> "<p>Haml code!</p>\n"

require 'haml'

class Tax_Report_HTML
  def self.write(orders, path)
    engine = Haml::Engine.new(File.read("tax_report_template.html.haml"))
    content = engine.render(Object.new, :orders => orders)
    File.open(path, 'w') { |io| 
      io << content
    }
  end
end