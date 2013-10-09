class SiteBase
  def initialize(args)
    @id = args[:id]
    @url = @format_url % @id
  end

  def url
    @url
  end
end
