class WineMonitorsCell < Cell::Rails
  cache :categories, :expires_in => 2.hours do |cell, options|
    "#{cell}_#{options[:class]}##{options[:category]}"
  end

  def categories(args)
    @category = args[:category]
    @class = args[:class]
    render
  end

  def tags(args)
    @args = args[:args]
    @wine_filter = WineFilter.new
    render
  end

end
