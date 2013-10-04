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

  taggable_on :categories
  has_and_belongs_to_many :wine_monitors

  validates :name, presence: true

  def to_s
    self.name
  end
end
