class WinePriceHistory
  include Mongoid::Document
  field :url, type: String
  field :current_price, type: Money
  field :tag_price, type: Money
  embedded_in :wine
  embedded_in :website
end
