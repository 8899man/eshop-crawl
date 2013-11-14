# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html
#puts 'ROLES'
#YAML.load(ENV['ROLES']).each do |role|
  #Role.mongo_session['roles'].insert({ :name => role })
  #puts 'role: ' << role
#end
#puts 'DEFAULT USERS'
#user = User.create! :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
#puts 'user: ' << user.name
#user.add_role :admin

Website.where(name: '京东', url: 'http://www.jd.com', lib: 'Jd').first_or_create
Website.where(name: '当当', url: 'http://www.dangdang.com', lib: 'Dangdang').first_or_create
Website.where(name: '也买酒', url: 'http://www.yesmywine.com/', lib: 'Yesmywine').first_or_create
Website.where(name: '也买酒商城', url: 'http://mall.yesmywine.com/', lib: 'YesmywineMall').first_or_create
Website.where(name: '品尚红酒', url: 'http://www.wine9.com/', lib: 'Wine9').first_or_create
Website.where(name: '亚马逊中国', url: 'http://www.amazon.com/?tag=liuzhouyeshi-23', lib: 'AmazonCn').first_or_create
