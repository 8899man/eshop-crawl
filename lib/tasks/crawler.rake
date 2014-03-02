# encoding: utf-8
namespace :crawler do
  desc "crawler price for all monitor"
  task :all => :environment do
    puts '开始获取最新价格'
    CrawlerController.new.get_all
    puts '获取完毕'
  end

  desc "crawler productions"
  task :all_list => :environment do
    puts '开始获取所有列表'
    CrawlerController.new.get_all_list
    puts '获取完毕'
  end

  desc "refilter all winemonitor"
  task :refilter_all => :environment do
    WineFilterController.new.refilter_all
  end
end
