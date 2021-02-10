class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :search_user, only: [:search, :result]

  def index
    if current_user.profession_id != 5
      @users = User.where(profession_id: 5)
    else
      @users = User.where.not(profession_id: 5)
    end
  end

  def show
    @user = User.find(params[:id])
    @url = @user.youtube.last(11)
  end

  def search
  end

  def result
    @results = @p.result
  end

  private

  def search_user
    @p = User.ransack(params[:q])
  end
end
