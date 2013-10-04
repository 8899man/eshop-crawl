class Dangdang
  def initialize(args)
    @format_url = 'http://product.dangdang.com/%d.html'
    @id = args[:id]
    @url = @format_url % @id
  end

  def url
    @url
  end
end
