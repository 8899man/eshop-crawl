class WinePrice
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::TaggableOn
  field :current_price, type: Money
  field :tag_price, type: Money
  field :shipping, type: Money
  field :started_at, type: DateTime,default:->{ Time.now }
  field :finished_at, type: DateTime
  field :event_string, type: String
  field :plus_string, type: String

  belongs_to :website
  belongs_to :wine_monitor
  taggable_on :event_types

  scope :recent, desc(:created_at)
  scope :cheapest, asc(:current_price)
  scope :running, where(:finished_at => nil)

  before_validation :last_not_same, on: :create
  after_create :set_wine

  def sn
    wine_monitor.try(:sn)
  end

  def last_not_same
    last_price = self.wine_monitor.wine_prices.recent.first
    if self.same?(last_price)
      self.errors.add :current_price, :same
    else
      last_price.finish if last_price
    end
  end

  def same?(wine_price)
    return false if wine_price.nil?
    #[current_price, tag_price, website, event_string] == [wine_price.current_price, wine_price.tag_price, wine_price.website, wine_price.event_string]
    [current_price, tag_price, website] == [wine_price.current_price, wine_price.tag_price, wine_price.website]
  end

  def set_wine
    attrs = {current_price: current_price, event_string: event_string}
    if wine_monitor.min_price.nil? or wine_monitor.min_price == 0 or current_price < wine_monitor.min_price
      attrs[:min_price] = current_price
    end
    wine_monitor.update_attributes attrs
  end

  def finish
    update_attribute :finished_at, Time.now if finished_at.nil?
  end

  def url
    wine_monitor.url
  end
end
