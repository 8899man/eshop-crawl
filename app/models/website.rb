class Website
  include Mongoid::Document
  field :name, type: String
  field :url, type: String, default: 'http://'
  field :lib
  has_many :wine_prices
  has_many :wine_monitors

  validates :name, presence: true, uniqueness: true
  validates :lib, presence: true, uniqueness: true

  after_update :update_monitors

  def update_monitors
    wine_monitors.each do |wine_monitor|
      wine_monitor.update_attributes lib: lib
    end
  end
end
