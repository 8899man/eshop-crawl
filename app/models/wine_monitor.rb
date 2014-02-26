class WineMonitor
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::TaggableOn
  field :lib, type: String
  field :sn, type: String
  field :min_price, type: Money
  field :current_price, type: Money
  field :price_per_liter, type: Money
  field :min_price_per_liter, type: Money
  field :name, type: String
  field :en_name, type: String
  field :description, type: String
  field :norm, type: Integer
  field :finished_at, type: DateTime
  field :event_string, type: String
  belongs_to :website
  belongs_to :user

  taggable_on :main_types
  taggable_on :categories
  taggable_on :countries
  taggable_on :types
  taggable_on :brands
  has_many :wine_prices
  has_and_belongs_to_many :wines
  has_many :comments, as: :commentable
  has_many :user_monitors
  has_many :wine_links

  scope :recent, desc(:updated_at)
  scope :cheapest, asc(:current_price)
  scope :running, where(:finished_at => nil)
  scope :finished, where(:finished_at.nin => [nil])
  scope :cheapest_per_liter, asc(:price_per_liter)

  #validates :wines, presence: true
  validates :sn, presence: true, uniqueness: { :scope => :website }

  after_update :set_price_per_liter, :set_wine_price, :monitoring_remind
  after_create :set_price_per_liter, :set_lib, :init_from_page, :get_price, :refilter

  def to_s
    name
  end

  def monitoring_remind
    user_monitors.where(:warn_price.gte => current_price).each do |user_monitor|
      UserMailer.user_monitor(user_monitor).deliver
    end if current_price and current_price > 0
  end

  def set_wine_price
    wines.each do |wine|
      if min_price.nil? or min_price == 0 or (current_price < min_price)
        update_attribute :min_price, current_price
      end

      if wine.min_price.nil? or wine.min_price == 0 or (current_price < wine.min_price)
        wine.update_attribute :min_price, current_price
      end

      the_cheapest = wine.wine_monitors.cheapest.first
      wine.update_attributes current_price: the_cheapest.try(:current_price), event_string: the_cheapest.try(:event_string)
    end if current_price
  end

  def url
    @url ||= lib.constantize.new(id: sn).url
  end

  def finish
    update_attribute :finished_at, Time.now if finished_at.nil?
  end

  def restart
    update_attribute :finished_at, nil unless finished_at.nil?
  end

  def set_price_per_liter
    if norm and norm > 0
      tmp_price_per_liter = (current_price / (norm.to_f / 1000)).to_money

      update_attribute :price_per_liter, tmp_price_per_liter if tmp_price_per_liter != price_per_liter
      update_attribute :min_price_per_liter, tmp_price_per_liter if min_price_per_liter.nil? or tmp_price_per_liter < min_price_per_liter
      set_wine_price_per_liter
    end if current_price
  end

  def set_wine_price_per_liter
    wines.each do |wine|
      if wine.min_price_per_liter.nil? or wine.min_price_per_liter == 0 or min_price_per_liter < wine.min_price_per_liter
        wine.update_attribute :min_price_per_liter, min_price_per_liter
      end
      wine.update_attribute :price_per_liter, wine.wine_monitors.cheapest_per_liter.first.try(:price_per_liter)
    end if min_price_per_liter
  end

  def set_lib
    update_attribute :lib, website.lib if website
  end

  def init_from_page
    (lib + "Crawler").constantize.new.init_from_page(self)
  end

  def get_price
    (lib + "Crawler").constantize.new.get(self)
  end

  def refilter
    WineFilterController.new.refilter_wine_monitor self
  end

  def self.categories
    all.map(&:categories).flatten.uniq
  end

  def self.category(category_name)
    WineMonitor.tagged_with_on(:categories, category_name)
  end
end
