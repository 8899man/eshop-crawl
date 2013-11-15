source 'http://ruby.taobao.org'
ruby '2.0.0'
gem 'rails', '3.2.14'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails', "< 3.0.0"
gem 'bootstrap-sass'
gem 'cancan'
gem 'devise'
gem 'figaro'
gem 'mongoid'
gem 'rolify'
gem 'simple_form'

gem 'money-rails'
gem 'cells'
gem 'rspec-cells', :group => [:development, :test]
gem 'mongoid_taggable_on'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'mini_magick', '>= 3.4'
gem 'rack-raw-upload', '>= 1.1.0'
gem "inherited_resources"
gem 'kaminari'
gem 'kaminari-bootstrap'
#gem "activeadmin", github: "gregbell/active_admin"
gem 'activeadmin-mongoid'
#gem 'jquery-ui-rails'
#gem 'jquery-ui-bootstrap-rails'
gem "typhoeus"
gem 'meta-tags', :require => 'meta_tags'#,git: 'git://github.com/destinyd/meta-tags.git'
gem "crummy", "~> 1.7.1"
gem 'sanitize'
gem 'rufus-scheduler'

#omniauth
gem 'omniauth'
gem 'omniauth-oauth2', git: 'git://github.com/intridea/omniauth-oauth2.git'
gem 'omniauth-baidu-social','>= 0.0.1',
  git: 'git://github.com/destinyd/omniauth-baidu-social.git'
gem 'sorted-mongoid'
gem 'openurl'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'quiet_assets'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'debugger'
end
group :production do
  gem 'thin'
end
group :test do
  gem 'capybara'
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
  gem 'mongoid-rspec'
end
