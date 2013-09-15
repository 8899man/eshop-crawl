class JdCrawler < Crawler
  def initialize(args={})
    @api_url_format = 'http://p.3.cn/prices/get?skuid=J_%d'
  end

  def get(wine_monitor)
    url = @api_url_format % wine_monitor.sn
    t = Typhoeus.get(url, followlocation: true)
    j = JSON.parse(t.body)[0]
    ph = wine_monitor.wine.wine_prices.create current_price: j['p'], tag_price: j['m']
  end

end
