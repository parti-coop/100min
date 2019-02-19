class Notice < ApplicationRecord
  include Likable

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  scope :order_recent, -> { order(created_at: :desc) }
end
