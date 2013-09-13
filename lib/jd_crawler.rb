class JdCrawler < Crawler
  def initialize(args={})
    @api_url_format = 'http://p.3.cn/prices/get?skuid=J_%d'
  end

  def get_all
    
  end

  def get(id)
    url = @api_url_format % id
    t = Typhoeus.get(url, followlocation: true)
    j = JSON.parse(t.body)[0]
    ph = WinePriceHistory.create current_price: j['p'], tag_price: j['m']
  end

end
