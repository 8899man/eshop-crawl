# encoding: utf-8
class YesmywineCrawler < Crawler
  def initialize(args={})
    @format_url = 'http://www.yesmywine.com/goods/%d.html'
    #@regx = /(<b class="myPrice">&yen<em>(?<current_price>.*?)<\/em>.*)?<b class="ymPrice">&yen<em>(?<tag_price>.*?)<\/em>.*(?<plus_string><dl class="clearifx".*?<\/dl>)/m
    @regx = /(<b class="myPrice">&yen<em>(?<current_price>.*?)<\/em>.*)?<b class="ymPrice">&yen<em>(?<tag_price>.*?)<\/em>/mi
    @regx_plus = /(?<plus_string><dl class="clearifx">.*?<\/dl>)/mi
    @regx_name = /【也买酒】(?<name>.*)_价格.*?<li><span class="en">(?<en_name>.*?)<\/span><\/li>/m
    @regx_description = [/<div class="xiangqing">(?<description>.*?)<\/div>/m , /<div class="proContent">(?<description>.*?<\/div>).*?<\/div>/m]
    @regx_finish = /很抱歉，您查找的页面或商品没有找到！/m
    @regx_norm = /<b>(?:容量|净含量|商品容量)<\/b>[\s\n\t]+(?<norm>[\d\.]+)((?<ml>m)?(?<l>l))?<\/span>/mi
  end

  def get(wine_monitor)
    url = @format_url % wine_monitor.sn
    hydra = Typhoeus::Hydra.new
    request = Typhoeus::Request.new url, {timeout: 10000}
    request.on_complete do |t|
      begin
        body = t.body.force_encoding('utf-8')
        return wine_monitor.finish if @regx_finish.match(body)
        m = @regx.match body
        m_plus = @regx_plus.match body
        ph = wine_monitor.wine_prices.create current_price: m[:current_price] || m[:tag_price],
          tag_price: m[:tag_price],
          event_string: Sanitize.clean(m_plus[:plus_string]).gsub(/[ \r\n]|促销信息：/m, ''),
          website: wine_monitor.website,
          plus_string: m_plus[:plus_string]
      rescue Exception => ex
        p "YesmywineCrawler get error #{url}"
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
        wine_monitor.finish if @regx_finish.match(body)
        match_name = @regx_name.match(body)
        name = match_name[:name].strip.gsub(/[\t\n ]+/,'')
        en_name = match_name[:en_name].strip.gsub(/[\t\n]+/,'')
        matches = @regx_description.map{|r| r.match body}
        description = matches.map{|match| match[:description]}.join("\n<p class='wine_crawler_hr'></p>\n")
        norm = get_norm(body)
        wine_monitor.update_attributes description: description, name: name, en_name: en_name, norm: norm
      rescue Exception => ex
        p "YesmywineCrawler init error #{url}"
      end
    end
    hydra.queue request
    hydra.run
  end

end

