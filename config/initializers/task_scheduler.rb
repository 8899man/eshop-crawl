require 'rufus/scheduler'

scheduler = Rufus::Scheduler.new
scheduler.every "4h", :first_at => Time.now + 60 do
  CrawlerController.new.get_all
end
