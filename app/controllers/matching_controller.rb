class MatchingController < ApplicationController
  before_action :authenticate_user!

  def index
    #フォローしているユーザーの取得
    follow_user_ids = Relationship.where(user_id: current_user.id).pluck(:follow_id)
    #相互フォローのユーザーの取得
    @match_users = Relationship.where(user_id: follow_user_ids, follow_id: current_user.id).map(&:user)
    @user = User.find(current_user.id)
  end
end
