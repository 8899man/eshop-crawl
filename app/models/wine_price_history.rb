class WinePriceHistory
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
end
