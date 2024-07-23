class MessageModel < ApplicationRecord
  include Searchable

  belongs_to :chat_model

  validates :number, presence: true, uniqueness: { scope: :chat_model }
end
