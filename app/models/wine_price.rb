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

  before_validation :last_not_same

  def last_not_same
    last_price = self.wine.wine_prices.recent.first
    if last_price and self.same?(last_price)
      self.errors.add :current_price, :same
    end
  end

  def same?(wine_price)
    [current_price,tag_price] == [wine_price.current_price, wine_price.tag_price]
  end
end
