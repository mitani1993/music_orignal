class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :search_user, only: [:search, :result]
  before_action :set_user, only: [:show, :follower, :followed]
  before_action :move_to_my_page, only: [:follower, :followed]

  def index
    if current_user.profession_id != 5
      @users = User.where(profession_id: 5)
    else
      @users = User.where.not(profession_id: 5)
    end
  end

  def show
    if @user.youtube.present?
      @url = @user.youtube.last(11)
    else
      @url = nil
    end
  end

  def search
  end

  def result
    @results = @p.result
  end

  def follower
  end

  def followed
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def search_user
    @p = User.ransack(params[:q])
  end

  def move_to_my_page
    redirect_to user_path(current_user) unless @user == current_user
  end
end
