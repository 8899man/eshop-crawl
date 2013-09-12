class Website
  include Mongoid::Document
  field :name, type: String
  field :url, type: String
  has_many :wine_price_histories
end
