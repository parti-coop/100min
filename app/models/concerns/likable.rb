require 'active_support/concern'

module Likable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :likable, dependent: :destroy
  end

  def like_by? someone
    false if someone.blank?

    likes.exists?(user: someone)
  end
end
