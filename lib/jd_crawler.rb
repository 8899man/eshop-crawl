class JdCrawler < Crawler
  def initialize(args={})
    @format_api_url = 'http://p.3.cn/prices/get?skuid=J_%d'
    @format_url = 'http://item.jd.com/%d.html'
    @format_event_url = 'http://jprice.360buy.com/pageadword/%d-1-1.html?callback=Promotions.set'
    @regx_event_json = /Promotions.set\((?<event_string>.*)\);/
    @regx_description = [/(?<description><ul class="detail-list">.*?<\/ul>)/m , /<div class="detail-content">(?<description>.*?)<\/div>/m]
  end

  def get(wine_monitor)
    price_url = @format_api_url % wine_monitor.sn
    event_url = @format_event_url % wine_monitor.sn
    url = @format_url % wine_monitor.sn
    hydra = Typhoeus::Hydra.new
    request = Typhoeus::Request.new price_url, {timeout: 10000}
    request.on_complete do |t|
      begin
        j = JSON.parse(t.body)[0]
        ty = Typhoeus.get(event_url, followlocation: true)
        m = @regx_event_json.match(ty.body)
        if j['id'] and j['id'] == 'J_' + wine_monitor.sn and j['p'] == '-1'
          wine_monitor.finish
        else
          ph = wine_monitor.wine_prices.create current_price: j['p'], tag_price: j['m'], website: wine_monitor.website, plus_string: m['event_string']
        end
      rescue Exception => ex
        p 'JdCrawler get error'
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
