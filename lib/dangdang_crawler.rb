class DangdangCrawler < Crawler
  def initialize(args={})
    @format_url = 'http://product.dangdang.com/%d.html'
    @regx = /<span id="salePriceTag">&yen;(?<current_price>[0-9\.]+)<\/span>.*<i class="m_price" id="originalPriceTag">&yen;&nbsp;(?<tag_price>[0-9\.]+)<\/i>/m
    @regx_event = /<div class="event clearfix">(?<event_string>.*?)<a[^>]+>/m
    @regx_description = [/<textarea style="height:0px;border-width:0px;">(?<description>.*?)<\/textarea>/m]
  end

  def get(wine_monitor)
    url = @format_url % wine_monitor.sn
    hydra = Typhoeus::Hydra.new
    request = Typhoeus::Request.new url, {timeout: 10000}
    request.on_complete do |t|
      begin
        body = t.body.encode('utf-8','gbk')
        m = @regx.match body
        e = @regx_event.match body
        ph = wine_monitor.wine_prices.create current_price: m[:current_price],
          tag_price: m[:tag_price],
          url: url,
          event_string: (e ? Sanitize.clean(e[:event_string]).gsub(/[ \r\n]/m, '') : nil),
          website: wine_monitor.website,
          plus_string: (e ? e[:event_string] : nil)
      rescue Exception => ex
        p 'DangdangCrawler get error'
      end
    end
    hydra.queue request
    hydra.run
  end

  def get_description(wine_monitor)
    url = @format_url % wine_monitor.sn
    hydra = Typhoeus::Hydra.new
    request = Typhoeus::Request.new url, {timeout: 10000, followlocation: true}
    request.on_complete do |t|
      begin
        body = t.body.encode('utf-8','gbk')
        matches = @regx_description.map{|r| r.match body}
        description = matches.map{|match| match[:description]}.join("\n<p class='wine_crawler_hr'></p>\n")
        wine_monitor.update_attribute :description, description
      rescue Exception => ex
        p 'JdCrawler error'
      end
    end
    hydra.queue request
    hydra.run
  end

end
