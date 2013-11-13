require 'rufus/scheduler'

scheduler = Rufus::Scheduler.new
scheduler.every "2h", :first_at => Time.now + 60 do
  CrawlerController.new.get_all
end
