class WineMonitor
  include Mongoid::Document
  include Mongoid::Timestamps
  field :lib, type: String
  field :sn, type: String
  belongs_to :wine
  belongs_to :website
  has_many :wine_prices

  validates :wine_id, presence: true
end
