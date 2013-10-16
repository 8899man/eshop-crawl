class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :content, type: String
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  attr_accessible :content

  scope :recent, desc(:created_at)
  scope :system, where(commentable: nil)
  scope :with_commentable, not_in(commentable: nil)
  scope :sidebar_comments, with_commentable.recent.limit(10)

  validates :content, length: 1..300
end
