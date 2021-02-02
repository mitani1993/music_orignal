class RelationshipsController < ApplicationController
  before_action :set_user

  def create
    if current_user.follow(@user)
      respond_to :js
    else
      render "users/show"
    end
  end

  def destroy
    if current_user.unfollow(@user)
      respond_to :js
    end
  end

  private
  def set_user
    @user = User.find(params[:follow_id])
  end
end
