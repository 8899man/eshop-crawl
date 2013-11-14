# encoding: utf-8
class YesmywineMallCrawler
  def initialize(args={})
    @format_url = 'http://www.yesmywine.com/goods/%d.html'
    @regx_price = /(<b class=rmbPrice >(?<current_price>.*?)<\/b>.*)?商城价：&yen(?<tag_price>[\d\.]+)<\/li>/mi
    @regx_price_tuan = /(¥<strong>(?<current_price>.*?)<\/strong>.*)?<em>原价<\/em><i>(?<tag_price>[\d\.]+)<\/i>/mi
    @regx_event_string = /<!-- 参加的活动名 -->(?<plus_string>.*?)<!-- 手机活动 -->/mi
    @regx_name = /<h1>(?<name>.*?)<\/h1>/m
    @regx_name_tuan = /<h3 class="tuan-title">(?<name>.*?)<\/h3>/m
    @regx_description = [/<div class="xiangqing">(?<description>.*?)<\/div>/m , /<div class="proContent">(?<description>.*?)<\/div>[\s\n]+<\/div>[\s\n]+<!-- 单品页-用户评论 -->/m]
    @regx_finish = /很抱歉，您查找的页面或商品没有找到！/m
    @regx_norm = /<b>(?:容量|净含量|商品容量)<\/b>[\s\n\t]+(?<norm>[\d\.]+)((?<ml>m)?(?<l>l))?<\/span>/mi
  end

  def get(wine_monitor)
    url = @format_url % wine_monitor.sn
    hydra = Typhoeus::Hydra.new
    request = Typhoeus::Request.new url, {timeout: 10000, followlocation: true}
    request.on_complete do |t|
      begin
        body = t.body.force_encoding('utf-8')
        return wine_monitor.finish if @regx_finish.match(body)
        m = @regx_price.match body
        m = @regx_price_tuan.match(body) unless m
        m_event_string = @regx_event_string.match body
        ph = wine_monitor.wine_prices.create current_price: m[:current_price] || m[:tag_price],
          tag_price: m[:tag_price],
          url: url,
          event_string: m_event_string ? Sanitize.clean(m_event_string[:plus_string]).gsub(/[ \r\n]|促销信息：/m, '') : nil,
          website: wine_monitor.website,
          plus_string: m_event_string ? m_event_string[:plus_string] : nil
      rescue Exception => ex
        p "YesmywineMallCrawler get error #{url}"
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
        match_name = @regx_name_tuan.match(body) unless match_name
        name = match_name[:name].strip.gsub(/[\t\n]+/,'')
        match_norm = @regx_norm.match(body)
        norm = match_norm[:norm]
        norm = norm.to_f * 1000 if !match_norm[:ml] and match_norm[:l]
        matches = @regx_description.map{|r| r.match body}
        description = matches.map{|match| match[:description]}.join("\n<p class='wine_crawler_hr'></p>\n")
        wine_monitor.update_attributes description: description, name: name, norm: norm
      rescue Exception => ex
        p "YesmywineMallCrawler init error #{url}"
      end
    end
    hydra.queue request
    hydra.run
  end

end

