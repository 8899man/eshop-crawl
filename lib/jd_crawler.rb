class JdCrawler < Crawler
  def initialize(args={})
    @format_api_url = 'http://p.3.cn/prices/get?skuid=J_%d'
    @format_url = 'http://item.jd.com/%d.html'
    @format_event_url = 'http://jprice.360buy.com/pageadword/%d-1-1.html?callback=Promotions.set'
    @regx_event_json = /Promotions.set\((?<event_string>.*)\);/
    @regx_name = /<h1>(?<name>.*)<\/h1>/m
    @regx_description = [/(?<description><ul class="detail-list">.*?<\/ul>)/m , /<div class="detail-content">(?<description>.*?)<\/div>\s+<\/div>\s+<div class="mc  hide" data-widget="tab-content" id="product-detail-2">/m]
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
          plus_string = m['event_string']
          events = JSON.parse(plus_string)['promotionInfoList']
          event_strings = []
          unless events.blank?
            events.each do |event|
              event_strings.push "直降#{event['discount']}" if event['discount']
              event_strings.push "满 #{event['discount']} 减 #{event['reward']}" if event['reward']
              event_strings.push "赠 #{event['adwordCouponList'][0]['couponQouta']} 京卷" unless event['adwordCouponList'].blank?
            end
          end
          ph = wine_monitor.wine_prices.create current_price: j['p'], tag_price: j['m'], website: wine_monitor.website, plus_string: plus_string, event_string: event_strings.join(',')
        end
      rescue Exception => ex
        p 'JdCrawler get error'
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
        body = t.body.encode('utf-8','gbk')
        name = @regx_name.match(body)[:name].strip
        matches = @regx_description.map{|r| r.match body}
        description = matches.map{|match| match[:description]}.join("\n<p class='wine_crawler_hr'></p>\n")
        description.gsub! /data-lazyload/,'src'
        wine_monitor.update_attributes description: description, name: name
      rescue Exception => ex
        p 'JdCrawler error'
      end
    end
    hydra.queue request
    hydra.run
  end

end
