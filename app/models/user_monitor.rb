class UserMonitor
  include Mongoid::Document
  include Mongoid::Timestamps
  field :warn_price, type: Money, default: 10
  belongs_to :user
  belongs_to :wine_monitor

  scope :recent, desc(:updated_at)

  validates :warn_price, presence: true, uniqueness: { :scope => [:user_monitor, :wine_monitor] }
end
