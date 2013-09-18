class DangdangCrawler < Crawler
  def initialize(args={})
    @url_format = 'http://product.dangdang.com/%d.html'
    @regx = /<span id="salePriceTag">&yen;(?<current_price>[0-9\.]+)<\/span>.*<i class="m_price" id="originalPriceTag">&yen;&nbsp;(?<tag_price>[0-9\.]+)<\/i>/m
    @regx_event = /<div class="event clearfix">(?<event_string>.*?)<a[^>]+>/m
  end

  def get(wine_monitor)
    url = @url_format % wine_monitor.sn
    hydra = Typhoeus::Hydra.new
    request = Typhoeus::Request.new url, {timeout: 10000}
    request.on_complete do |t|
      begin
        body = t.body.encode('utf-8','gbk')
        m = @regx.match body
        e = @regx_event.match body
        ph = wine_monitor.wine.wine_prices.create current_price: m[:current_price], tag_price: m[:tag_price], url: url, event_string: (e ? Sanitize.clean(e[:event_string]).gsub(/[ \r\n]/m,'') : nil), website: wine_monitor.website
      rescue
        p 'DangdangCrawler error'
      end
    end
    hydra.queue request
    hydra.run
    #t = Typhoeus.get(url, followlocation: true )

  end
end
