class Wine
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::TaggableOn
  field :name, type: String
  field :introduction, type: String
  field :description, type: String
  field :min_price, type: Money
  field :current_price, type: Money
  field :price_per_liter, type: Money
  field :min_price_per_liter, type: Money
  field :fit_price, type: Money
  mount_uploader :image, ImageUploader

  taggable_on :categories
  has_and_belongs_to_many :wine_monitors
  has_many :comments, as: :commentable

  validates :name, presence: true

  scope :recent, desc(:created_at)
  scope :cheapest, asc(:current_price)
  scope :cheapest_per_liter, asc(:price_per_liter)

  def to_s
    self.name
  end
end
