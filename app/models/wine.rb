class Wine
  include Mongoid::Document
  field :name, type: String
  field :introduction, type: String
  field :description, type: String
  field :min_price, type: Money
  field :current_price, type: Money
  field :min_starting_price, type: Money
  field :max_starting_price, type: Money
  has_many :wine_price_histories
end
