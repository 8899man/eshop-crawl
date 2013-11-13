class Dangdang < SiteBase
  def initialize(args)
    @format_url = 'http://product.dangdang.com/%d.html'
    super(args)
  end

  def regex_id
    @regex_id ||= /http:\/\/product.dangdang.com\/(?<id>\d+).html/i
  end
end
