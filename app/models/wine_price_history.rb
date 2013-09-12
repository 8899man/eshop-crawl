class WinePriceHistory
  include Mongoid::Document
  field :url, type: String
  field :current_price, type: Money
  field :tag_price, type: Money
  belongs_to :wine
  belongs_to :website
end
