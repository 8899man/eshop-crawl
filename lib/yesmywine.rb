class Yesmywine < SiteBase
  def initialize(args)
    @format_url = 'http://www.yesmywine.com/goods/%d.html'
    super(args)
  end
end
