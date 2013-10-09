class Jd < SiteBase
  def initialize(args)
    @format_url = 'http://item.jd.com/%d.html'
    super(args)
  end
end
