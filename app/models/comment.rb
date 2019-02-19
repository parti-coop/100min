class Comment < ApplicationRecord
  include Likable
  paginates_per 20

  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: true

  scope :order_recent, -> { order(created_at: :desc) }
end
