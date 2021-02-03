class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room

  validates :message, presence: true
end
