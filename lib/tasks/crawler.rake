# encoding: utf-8
namespace :crawler do
  desc "crawler all monitor"
  task :all => :environment do
    puts '开始获取最新价格'
    CrawlerController.new.get_all
    puts '获取完毕'
  end

  task :all_list => :environment do
    puts '开始获取所有列表'
    CrawlerController.new.get_all
    puts '获取完毕'
  end
end
