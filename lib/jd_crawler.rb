class JdCrawler < Crawler
  def initialize(args={})
    @api_url_format = 'http://p.3.cn/prices/get?skuid=J_%d'
    @url_format = 'http://item.jd.com/%d.html'
  end

  def get(wine_monitor)
    price_url = @api_url_format % wine_monitor.sn
    url = @url_format % wine_monitor.sn
    t = Typhoeus.get(price_url, followlocation: true)
    j = JSON.parse(t.body)[0]
    ph = wine_monitor.wine.wine_prices.create current_price: j['p'], tag_price: j['m'], url: url
  end

end
