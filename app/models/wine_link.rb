class WineLink
  include Mongoid::Document
  include Mongoid::Timestamps
  field :url, type: String
  field :warn_price, type: Money
  field :deal_at, type: DateTime
  belongs_to :user
  belongs_to :wine_monitor

  validates :url, presence: true, format: {with: /^https?:\/\/.*/i }, uniqueness: true
  scope :undeal, where(deal_at: nil)

  after_create :test_deal
  def test_deal
    YAML.load(ENV['CRAWLS']).each do |site|
      site_klass = site.constantize.new({})
      if site_klass.is?(url)
        site_klass.url = url
        self.wine_monitor = WineMonitor.where(sn: site_klass.get_id, website: Website.where(lib: site).first).first_or_create(user: user)
        save! if changed?
        if warn_price and warn_price != 0
          user.user_monitors.create warn_price: warn_price, wine_monitor: wine_monitor
        end
        deal
        return
      end
    end
  end

  def deal
    update_attribute :deal_at, Time.now
  end
end
