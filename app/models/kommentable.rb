class Kommentable < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy

  def self.interview
    self.find_by(slug: :interview)
  end

  def self.data
    self.find_by(slug: :data)
  end

  def self.value
    self.find_by(slug: :value)
  end

  def path_slug
    "kommentables_#{self.slug}"
  end
end
