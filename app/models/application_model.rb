class ApplicationModel < ApplicationRecord
    has_many :chat_models
    validates :name, presence: true, uniqueness: true
    validates :token, presence: true, uniqueness: true
end
