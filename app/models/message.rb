class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room

  validates :message, presence: true

  after_create_commit { ChatMessageBroadcastJob.perform_later self }
end
