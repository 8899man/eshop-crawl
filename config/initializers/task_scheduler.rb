require 'rufus/scheduler'

scheduler = Rufus::Scheduler.new
scheduler.every "6h", :first_at => Time.now + 1800 do
  CrawlerController.new.get_all
end
