# encoding: utf-8
class AmazonCnCrawler < Crawler
  def initialize(args={})
    @format_url = 'http://www.amazon.cn/dp/%s'
    @regx_price = /(class="listprice">￥ (?<tag_price>[\d\.]+)<\/span>.*)?<b class="priceLarge">￥ (?<current_price>[\d\.]+)<\/b>/m
    @regx_name = /<span id="btAsinTitle">.*?<span style="padding-left: 0" >(?<name>.*?)<\/span>/m
    @regx_description = [/<div class="h1"><strong>产品信息<\/strong><\/div>.*?<div class="content">(?<description>.*)<\/div>.*?<\/div>.*?<a name="productDetails" id="productDetails">/m, /<h2>商品特性<\/h2>.*?<div class="content">(?<description>.*?)<\/div>/m , /<h2>商品描述<\/h2>.*?<div class="content">(?<description>(?:.*?<div class="emptyClear"> <\/div>){1,}.*?<\/div>).*?(?:importantInformation)?/m ]
    @regx_norm = /液体容量<\/span><span>(?<norm>[\d\.]+)( (?<ml>毫)?(?<l>升))?<\/span>/mi
  end

  def get(wine_monitor)
    url = @format_url % wine_monitor.sn
    hydra = Typhoeus::Hydra.new
    request = Typhoeus::Request.new url, {timeout: 10000, followlocation: true}
    request.on_complete do |t|
      begin
        body = t.body.force_encoding('utf-8')
        m = @regx_price.match body
        ph = wine_monitor.wine_prices.create current_price: m[:current_price],
          tag_price: m[:tag_price] || m[:current_price],
          website: wine_monitor.website
      rescue Exception => ex
        p "AmazonCnCrawler get error #{url}"
      end
    end
    hydra.queue request
    hydra.run
  end

  def init_from_page(wine_monitor)
    url = @format_url % wine_monitor.sn
    hydra = Typhoeus::Hydra.new
    request = Typhoeus::Request.new url, {timeout: 10000, followlocation: true}
    request.on_complete do |t|
      begin
        body = t.body.force_encoding('utf-8')
        match_name = @regx_name.match(body)
        name = match_name[:name].strip.gsub(/[\t\n]+/,'')
        norm = get_norm(body)
        matches = @regx_description.map{|r| r.match body}.compact
        description = matches.map{|match| match[:description]}.join("\n<p class='wine_crawler_hr'></p>\n")
        wine_monitor.update_attributes description: description, name: name, norm: norm
      rescue Exception => ex
        p "AmazonCnCrawler init error #{url}"
      end
    end
    hydra.queue request
    hydra.run
  end

end

