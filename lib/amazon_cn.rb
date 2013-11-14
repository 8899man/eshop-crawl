class AmazonCn < SiteBase
  def initialize(args)
    @format_url = 'http://www.amazon.cn/dp/%s'
    super(args)
  end

  def regex_id
    @regex_id ||= /http:\/\/www\.amazon\.cn\/(?:.*?dp|gp\/product)\/(?<id>[^\/]+)\/?/i
  end

  def ad_url
    @url + "/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=536&creative=3200&linkCode=as2&tag=liuzhouyeshi-23&creativeASIN=#{@id}"
  end
end
