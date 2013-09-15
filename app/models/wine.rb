class Wine
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::TaggableOn
  field :name, type: String
  field :introduction, type: String
  field :description, type: String
  field :min_price, type: Money
  field :current_price, type: Money
  field :fit_price, type: Money
  mount_uploader :image, ImageUploader

  has_many :wine_prices
  has_many :wine_monitors
  taggable_on :categories

  def to_s
    self.name
  end
end
