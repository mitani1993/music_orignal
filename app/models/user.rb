class User < ApplicationRecord
  has_one_attached :image
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  with_options presence: true do
    validates :name
    validates :area_id
    validates :profession_id
  end

  def update_without_current_password(params, *options)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  extend ActiveHash::Associations::ActiveRecordExtensions
    belongs_to :area
    belongs_to :profession
    validates :area_id, numericality: { other_than: 1 }
    validates :profession_id, numericality: { other_than: 1 } 
end
