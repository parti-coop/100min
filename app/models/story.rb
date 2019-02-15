class Story < ApplicationRecord
  has_many :likes, as: :likable, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
  mount_uploader :image, DefaultImageUploader

  scope :order_recent, -> { order(created_at: :desc) }

  def like? someone
    false if someone.blank?

    likes.exists?(user: someone)
  end
end
