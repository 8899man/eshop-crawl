# encoding: utf-8
namespace :crawler do
  desc "crawler all monitor"
  task :all => :environment do
    puts '开始获取内容'
    CrawlerController.new.get_all
    puts '获取完毕'
  end
end
