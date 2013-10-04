class WineMonitor
  include Mongoid::Document
  include Mongoid::Timestamps
  field :lib, type: String
  field :sn, type: String
  belongs_to :website
  has_many :wine_prices
  has_and_belongs_to_many :wines

  validates :wines, presence: true
  def url
    @url ||= lib.capitalize.constantize.new(id: sn).url
  end
end
