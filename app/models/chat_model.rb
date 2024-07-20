class ChatModel < ApplicationRecord
  belongs_to :application_model
  has_many :message_models

  validates :number, presence: true, uniqueness: { scope: :application_model } 
end
