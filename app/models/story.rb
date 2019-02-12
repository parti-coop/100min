class Story < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true
  mount_uploader :image, DefaultImageUploader

  scope :order_recent, -> { order(created_at: :desc) }
end
