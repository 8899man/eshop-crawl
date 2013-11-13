class YesmywineMall < SiteBase
  def initialize(args)
    @format_url = 'http://www.yesmywine.com/goods/%d.html'
    super(args)
  end

  def regex_id
    @regex_id ||= /http:\/\/mall.yesmywine.com\/shop\/.*\/item-(?<id>\d+)/i
  end
end
