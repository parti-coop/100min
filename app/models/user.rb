class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :omniauthable

  has_many :stories, dependent: :destroy
  has_many :notices, dependent: :destroy
  has_many :suggestions, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates_format_of       :email, with: Devise.email_regexp, allow_blank: true, if: :will_save_change_to_email?
  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_length_of       :password, within: Devise.password_length, allow_blank: true
  # validate :valid_confirmation, on: :create

  scope :order_recent, -> { order(created_at: :desc) }
  scoped_search on: [:name, :email]

  mount_uploader :profile_image, DefaultImageUploader

  def self.find_for_omniauth(provider, uid)
    where(provider: provider, uid: uid).first
  end

  def self.parse_omniauth(data, params)
    result = { provider: data['provider'],
      uid: data['uid'],
      email: data['info']['email'],
      image: data['info']['image'],
      name: data['info']['name'] || data['info']['nickname'] }

    remember_me = params.try(:fetch, "remember_me", false)
    result[:remember_me] = remember_me

    # if params.try(:any?)
    #   %w(confirmation_mailing confirmation_privacy confirmation_terms).each do |confirmation_param|
    #     result[confirmation_param.to_sym] = (params.try(:fetch, confirmation_param, false) == 'y')
    #   end
    # end

    result
  end

  def self.find_or_initialize_for_omniauth(parsed_data)
    user = User.find_or_initialize_by(provider: parsed_data[:provider], uid: parsed_data[:uid]) do |user|
      user.email = parsed_data[:email]
      user.name = parsed_data[:name] || user.email
      user.password = Devise.friendly_token[0,20]
      user.remote_profile_image_url = parsed_data[:image]
      # user.confirmation_mailing = parsed_data[:confirmation_mailing]
      # user.confirmation_privacy = parsed_data[:confirmation_privacy]
      # user.confirmation_terms = parsed_data[:confirmation_terms]
    end
    user.remember_me = parsed_data[:remember_me]
    user
  end

  def email_required?
    false
  end

  def confirmation?
    confirmation_terms == true and confirmation_privacy == true
  end

  def admin?
    %w(sjjungkr@gmail.com contact@parti.xyz roots96@hanmail.net foroso@gmail.com).include? self.email
  end

  private

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  # def valid_confirmation
  #   if confirmation_terms != true or confirmation_privacy != true
  #     errors.add(:confirmation, I18n.t('errors.messages.users.need_to_confirm'))
  #   end
  # end
end
