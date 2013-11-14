# encoding: utf-8
class Wine9Crawler < Crawler
  def initialize(args={})
    @format_url = 'http://www.wine9.com/%d.html'
    @format_api_url = 'http://www.wine9.com/product.php?sku=%d&m=loadinfo&promcode=null'
    @regx_price = /<b class="lt" id="marketPriceId">(?<tag_price>[\d\.]+)<\/b> 元/m
    @regx_name = /<h1 class="title_left">(?<name>.*?)<\/h1>/m
    @regx_description = [/<div class="detailed_tab_att1bg">(?<description>.*?)<\/div>[\s\n\t]+<!--  -->/m , /<div class="t2">About  Product<\/div>.*?<div class="cont">(?<description>.*?)<script/m]
    @regx_norm = /<b>含量&nbsp\;<\/b> (?<norm>[\d\.]+)((?<ml>m)?(?<l>l))?<\/li>/mi
  end

  def get(wine_monitor)
    price_url = @format_api_url % wine_monitor.sn
    url = @format_url % wine_monitor.sn
    hydra = Typhoeus::Hydra.new
    request = Typhoeus::Request.new price_url, {timeout: 10000, followlocation: true}
    request.on_complete do |t|
      begin
        j = JSON.parse(t.body)
        ty = Typhoeus.get(url, followlocation: true)
        body = ty.body.force_encoding('gb2312').encode('utf-8')
        m = @regx_price.match body
        ph = wine_monitor.wine_prices.create current_price: j['promprice'] || m[:tag_price],
          tag_price: m[:tag_price],
          website: wine_monitor.website
      rescue Exception => ex
        p "Wine9Crawler get error #{url} or #{price_url}"
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
        body = t.body.force_encoding('gb2312').encode('utf-8')
        match_name = @regx_name.match(body)
        name = match_name[:name].strip.gsub(/[\t\n]+/,'')
        norm = get_norm(body)
        matches = @regx_description.map{|r| r.match body}
        description = matches.map{|match| match[:description]}.join("\n<p class='wine_crawler_hr'></p>\n")
        wine_monitor.update_attributes description: description, name: name, norm: norm
      rescue Exception => ex
        p "Wine9Crawler init error #{url}"
      end
    end
    hydra.queue request
    hydra.run
  end

end

