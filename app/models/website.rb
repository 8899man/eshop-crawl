class Website
  include Mongoid::Document
  field :name, type: String
  field :url, type: String
  has_many :wine_prices
  has_many :wine_monitors
end
