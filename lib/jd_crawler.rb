class JdCrawler < Crawler
  def initialize(args={})
    @api_url_format = 'http://p.3.cn/prices/get?skuid=J_%d'
    @url_format = 'http://item.jd.com/%d.html'
    @event_url_format = 'http://jprice.360buy.com/pageadword/%d-1-1.html?callback=Promotions.set'
    @regx_event_json = /Promotions.set\((?<event_string>.*)\);/
  end

  def get(wine_monitor)
    price_url = @api_url_format % wine_monitor.sn
    event_url = @event_url_format % wine_monitor.sn
    url = @url_format % wine_monitor.sn
    hydra = Typhoeus::Hydra.new
    request = Typhoeus::Request.new price_url, {timeout: 10000}
    request.on_complete do |t|
      begin
        j = JSON.parse(t.body)[0]
        ty = Typhoeus.get(event_url, followlocation: true)
        m = @regx_event_json.match(ty.body)
        ph = wine_monitor.wine_prices.create current_price: j['p'], tag_price: j['m'], url: url, website: wine_monitor.website, plus_string: m['event_string'], wine: wine_monitor.wine
      rescue Exception => ex
        debugger
        p 'JdCrawler error'
      end
    end
    hydra.queue request
    hydra.run
  end

end
