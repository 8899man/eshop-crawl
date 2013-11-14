class Wine9 < SiteBase
  def initialize(args)
    @format_url = 'http://www.wine9.com/%d.html'
    super(args)
  end

  def regex_id
    @regex_id ||= /http:\/\/www.wine9.com\/(?<id>\d+).html/i
  end
end
