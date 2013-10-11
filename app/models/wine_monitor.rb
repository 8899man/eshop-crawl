class WineMonitor
  include Mongoid::Document
  include Mongoid::Timestamps
  field :lib, type: String
  field :sn, type: String
  field :min_price, type: Money
  field :current_price, type: Money
  field :name, type: String
  field :en_name, type: String
  field :description, type: String
  field :norm, type: String
  field :finished_at, type: DateTime
  belongs_to :website
  has_many :wine_prices
  has_and_belongs_to_many :wines

  scope :recent, desc(:created_at)
  scope :cheapest, asc(:current_price)
  scope :running, where(:finished_at => nil)

  validates :wines, presence: true

  after_update :set_wine_price
  after_create :set_lib,:init_from_page

  def to_s
    name
  end

  def set_wine_price
    wines.each do |wine|
      if min_price.nil? or min_price == 0 or current_price < min_price
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

  def set_lib
    update_attribute :lib, website.lib
  end

  def init_from_page
    (lib.capitalize + "Crawler").constantize.new.init_from_page(self)
  end
end
