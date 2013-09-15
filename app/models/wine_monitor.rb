class WineMonitor
  include Mongoid::Document
  include Mongoid::Timestamps
  field :lib, type: String
  field :sn, type: String
  belongs_to :wine
  belongs_to :website

  validates :wine_id, presence: true
end
