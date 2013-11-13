class Jd < SiteBase
  def initialize(args)
    @format_url = 'http://item.jd.com/%d.html'
    super(args)
  end

  def regex_id
    @regex_id ||= /http:\/\/item.jd.com\/(?<id>\d+).html/i
  end
end
