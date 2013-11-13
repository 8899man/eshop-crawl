class Yesmywine < SiteBase
  def initialize(args)
    @format_url = 'http://www.yesmywine.com/goods/%d.html'
    super(args)
  end

  def regex_id
    @regex_id ||= /http:\/\/www.yesmywine.com\/goods\/(?<id>\d+).html/i
  end
end
