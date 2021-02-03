class ChatRoomsController < ApplicationController

  def create
    #自分がいるチャットルームを取得
    current_user_rooms = RoomUser.where(user_id: current_user.id).map(&:chat_room)
    #自分がいるチャットルームでかつ、マッチング一覧ページからクリックしたユーザーがいるチャットルームを取得
    chat_room = RoomUser.where(user_id: current_user_rooms, user_id: params[:user_id]).map(&:chat_room).first
    if chat_room.blank?
      chat_room = ChatRoom.create
      RoomUser.create(chat_room: chat_room, user_id: current_user.id)
      RoomUser.create(chat_room: chat_room, user_id: params[:user_id])
    end
    redirect_to chat_room_path(chat_room)
  end

  def show
    @chat_room = ChatRoom.find(params[:id])
    @chat_room_user = @chat_room.room_users.where.not(user_id: current_user.id).first.user
    @chat_messages = Message.where(chat_room: @chat_room)
  end
end
