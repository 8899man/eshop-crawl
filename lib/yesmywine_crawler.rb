# encoding: utf-8
class YesmywineCrawler
  def initialize(args={})
    @format_url = 'http://www.yesmywine.com/goods/%d.html'
    @regx = /<b class="myPrice">&yen<em>(?<current_price>.*?)<\/em>.*<b class="ymPrice">&yen<em>(?<tag_price>.*?)<\/em>.*(?<plus_string><dl class="clearifx">.*?<\/dl>)/m
    @regx_name = /【也买酒】(?<name>.*)_价格.*?<li><span class="en">(?<en_name>.*?)<\/span><\/li>/m
    @regx_description = [/<div class="xiangqing">(?<description>.*?)<\/div>/m , /<div class="proContent">(?<description>.*?)<\/div>[\s\n]+<!-- 用户评价  -->/m]
  end

  def get(wine_monitor)
    url = @format_url % wine_monitor.sn
    hydra = Typhoeus::Hydra.new
    request = Typhoeus::Request.new url, {timeout: 10000}
    request.on_complete do |t|
      begin
        body = t.body.force_encoding('utf-8')
        m = @regx.match body
        ph = wine_monitor.wine_prices.create current_price: m[:current_price],
          tag_price: m[:tag_price],
          url: url,
          event_string: Sanitize.clean(m[:plus_string]).gsub(/[ \r\n]/m, ''),
          website: wine_monitor.website,
          plus_string: m[:plus_string]
      rescue Exception => ex
        p 'YesmywineCrawler get error'
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
        match_name = @regx_name.match(body)
        name = match_name[:name].strip.gsub(/[\t\n ]+/,'')
        en_name = match_name[:en_name].strip.gsub(/[\t\n ]+/,'')
        matches = @regx_description.map{|r| r.match body}
        description = matches.map{|match| match[:description]}.join("\n<p class='wine_crawler_hr'></p>\n")
        wine_monitor.update_attributes description: description, name: name, en_name: en_name
      rescue Exception => ex
        p 'DangdangCrawler error'
      end
    end
    hydra.queue request
    hydra.run
  end

end

