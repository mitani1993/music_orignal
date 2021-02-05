class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  #アソシエーション
  has_many :sns_credentials
  has_many :room_users
  has_many :chat_rooms, through: :room_users
  has_many :messages
  has_one_attached :image
  #フォローしているユーザーとのアソシエーション
  has_many :relationships,foreign_key: "user_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :follow
  #フォローしてくれているユーザーとのアソシエーション
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "follow_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :user


  #バリデーション
  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze
  validates_format_of :password, with: PASSWORD_REGEX, on: :create, message: 'には英字と数字の両方を含めて半角で設定してください'
  validates :password, presence: true, on: :create

  with_options presence: true do
    validates :name
    validates :area_id
    validates :profession_id
  end


  #メソッド
  def update_without_current_password(params, *options)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end
    result = update(params, *options)
    clean_up_passwords
    result
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end


  #アクティブハッシュ
  extend ActiveHash::Associations::ActiveRecordExtensions
    belongs_to :area
    belongs_to :profession
    validates :area_id, numericality: { other_than: 1 }
    validates :profession_id, numericality: { other_than: 1 } 
end
