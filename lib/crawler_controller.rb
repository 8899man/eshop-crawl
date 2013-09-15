class CrawlerController
  def initialize(args={})
    @jd = JdCrawler.new
  end

  def get_all
    @wine_monitors = WineMonitor.all
    @wine_monitors.each do |wine_monitor|
      @jd.get wine_monitor
    end
  end
end

