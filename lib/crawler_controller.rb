class CrawlerController
  def initialize(args={})
    @jd = JdCrawler.new
    @dangdang = DangdangCrawler.new
  end

  def get_all
    @wine_monitors = WineMonitor.running
    @wine_monitors.each do |wine_monitor|
      case wine_monitor.lib
      when 'Jd'
        @jd.get wine_monitor
      when 'Dangdang'
        @dangdang.get wine_monitor
      end
    end
  end
end

