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

  AREA_DETAIL = [
    {
      code: 'KS',
      name: '수도권',
      date: '2019.7.13',
      location: nil,
      address: nil,
      map_url: nil
    },
    {
      code: 'FU',
      name: '강원권',
      date: '2019.6.28',
      location: '춘천세종호텔 사파이어홀',
      address: '강원도 춘천시 봉의산길31 춘천세종호텔 별관1동 2층 사파이어홀',
      map_url: 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3148.8858126442647!2d127.72905521501475!3d37.8863530135057!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3562e5e70c2b540f%3A0x3d73a6e1754b2e8!2z6rCV7JuQ64-EIOy2mOyynOyLnCDshozslpHrj5kg67SJ7J2Y7IKw6ri4IDMx!5e0!3m2!1sko!2skr!4v1556588713644!5m2!1sko!2skr'
    },
    {
      code: 'HJ',
      name: '호남•제주권',
      date: '2019.6.5',
      location: '광주 국립아시아문화전당',
      address: '광주광역시 동구 문화전당로 38 국립아시아문화전당 문화정보원 지하2층 콘퍼런스홀',
      map_url: 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3262.3991281903914!2d126.91808081493929!3d35.146665466710836!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x35718c84de58c767%3A0x12e1ec7dd846322a!2z6rWt66a97JWE7Iuc7JWE66y47ZmU7KCE64u5!5e0!3m2!1sko!2skr!4v1556588616672!5m2!1sko!2skr'
    },
    {
      code: 'CH',
      name: '충청권',
      date: '2019.6.10',
      location: '대전 컨벤션센터 그랜드볼룸',
      address: '대전광역시 유성구 엑스포로 107 DCC대전컨벤션센터 2층 그랜드볼룸',
      map_url: 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3212.4151543458242!2d127.38912061497251!3d36.3749426992218!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x356549856f487a11%3A0xd03c3bec141f8760!2z64yA7KCE7Luo67Kk7IWY7IS87YSw!5e0!3m2!1sko!2skr!4v1556588513995!5m2!1sko!2skr'
    },
    {
      code: 'BT',
      name: '영남권',
      date: '2019.5.30',
      location: '경남도청 대회의실(창원)',
      address: '경상남도 창원시 의창구 중앙대로 300 경상남도청 본관 4층 대회의실',
      map_url: 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3258.7559097111016!2d128.68923011494178!3d35.23744581179012!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x360df12bf0ddf1aa!2z6rK97IOB64Ko64-E7LKt!5e0!3m2!1sko!2skr!4v1556587977773!5m2!1sko!2skr'
    }
  ]

  AREA_CODE = Hash[Suggestion::AREA_DETAIL.map{ |area| [area[:code], area[:name]]}]

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
