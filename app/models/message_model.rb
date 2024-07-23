class MessageModel < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  belongs_to :chat_model

  validates :number, presence: true, uniqueness: { scope: :chat_model }
end
