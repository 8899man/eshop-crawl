class Jd
  def initialize(args)
    @format_url = 'http://item.jd.com/%d.html'
    @id = args[:id]
    @url = @format_url % @id
  end

  def url
    @url
  end


end
