class WineMonitor
  include Mongoid::Document
  include Mongoid::Timestamps
  field :lib, type: String
  field :sn, type: String
  field :min_price, type: Money
  field :current_price, type: Money
  field :description, type: String
  field :finished_at, type: DateTime
  belongs_to :website
  has_many :wine_prices
  has_and_belongs_to_many :wines

  scope :recent, desc(:created_at)
  scope :cheapest, asc(:current_price)
  scope :running, where(:finished_at => nil)

  validates :wines, presence: true

  after_update :set_wine_price
  after_create :get_description

  def set_wine_price
    wines.each do |wine|
      if wine.min_price == 0 or current_price < wine.min_price
        wine.update_attribute :min_price, current_price
      end
      wine.update_attribute :current_price, wine.wine_monitors.cheapest.first.try(:current_price)
    end
  end

  def url
    @url ||= lib.capitalize.constantize.new(id: sn).url
  end

  def finish
    update_attribute :finished_at, Time.now if finished_at.nil?
  end

  def get_description
    (lib.capitalize + "Crawler").constantize.new.get_description(self)
  end
end
