class WinePrice
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::TaggableOn
  field :url, type: String, default: 'http://'
  field :current_price, type: Money
  field :tag_price, type: Money
  field :started_at, type: DateTime
  field :finished_at, type: DateTime
  belongs_to :wine
  belongs_to :website
  taggable_on :event_types

  scope :recent,desc(:created_at)
  scope :cheapest,asc(:current_price)

  before_validation :last_not_same
  after_create :set_wine_price

  def last_not_same
    last_price = self.wine.wine_prices.recent.first
    if last_price and self.same?(last_price)
      self.errors.add :current_price, :same
    end
  end

  def same?(wine_price)
    [current_price,tag_price] == [wine_price.current_price, wine_price.tag_price]
  end

  def set_wine_price
    if wine.min_price == 0 or current_price < wine.min_price
      wine.update_attribute :min_price, current_price
    end
    wine.update_attribute :current_price, current_price
  end
end
