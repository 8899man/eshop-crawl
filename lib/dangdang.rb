class Dangdang < SiteBase
  def initialize(args)
    @format_url = 'http://product.dangdang.com/%d.html'
    super(args)
  end
end
