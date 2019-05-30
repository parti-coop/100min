class Snapshot < ApplicationRecord
  include Likable

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true
  validates :area_code, presence: true

  mount_uploader :image, DefaultImageUploader

  scope :order_recent, -> { order(created_at: :desc) }
  scope :order_hot, -> { order(Arel.sql('suggestions.reads_count + suggestions.comments_count * 20 + suggestions.likes_count * 10 desc')) }
  scoped_search on: [:body]

  def self.area_options
    Suggestion.area_options
  end

  def area_name
    Suggestion::AREA_CODE[self.area_code.to_sym].try(:fetch, :name)
  end

  def user_name
    real_user_name || user.name
  end
end
