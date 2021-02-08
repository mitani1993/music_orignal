class UsersController < ApplicationController
  before_action :authenticate_user!

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
end
