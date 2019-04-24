class Suggestion < ApplicationRecord
  include Likable

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :hashtags, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
  validates :area, presence: true
  validates :category, presence: true

  mount_uploader :image, DefaultImageUploader

  scope :order_recent, -> { order(created_at: :desc) }
  scope :order_hot, -> { order(Arel.sql('suggestions.reads_count + suggestions.comments_count * 20 + suggestions.likes_count * 10 desc')) }
  scoped_search on: [:title, :body]

  before_save :process_hashtags

  AREA_CODE = {
    'KS': '수도권',
    'CH': '충청권',
    'HJ': '호남권',
    'BT': '영남권',
    'FU': '강원권'
  }

  CATEGORY_CODE = {
    'PO': '정치',
    'EC': '경제',
    'SO': '사회',
    'CU': '문화/예술',
    'TE': '과학/기술',
    'ET': '기타'
  }

  def self.area_options
    AREA_CODE.map{ |code, name| [name, code]}
  end

  def self.category_options
    CATEGORY_CODE.map{ |code, name| [name, code]}
  end

  def area_name
    AREA_CODE[self.area.to_sym]
  end

  def category_name
    CATEGORY_CODE[self.category.to_sym]
  end

  HASHTAG_REGEX = /(?:\s|^)(#(?!(?:\d+|[ㄱ-ㅎ가-힣a-z0-9_]+?_|_[ㄱ-ㅎ가-힣a-z0-9_]+?)(?:\s|$))([ㄱ-ㅎ가-힣a-z0-9\-_]+))/i
  def self.parse_hastags(hashtags_str)
    return [] if hashtags_str.blank?
    hashtags_str.scan(HASHTAG_REGEX).map { |match| match[1].to_s.strip }.uniq.compact
  end

  def process_hashtags
    self.hashtags.destroy_all
    Suggestion.parse_hastags(self.raw_hashtags).each do |name|
      self.hashtags.build(name: name)
    end
  end
end
