class CreateMessageModelJob
  include Sidekiq::Job

  def perform(application_token, chat_number, message_number, body)
    @application = ApplicationModel.find_by!(token: application_token)
    @chat = @application.chat_models.find_by!(number: chat_number)
    ChatModel.transaction do
      @chat = ChatModel.lock.first
      @chat.messages_count = message_number
      @chat.save!
    end
    MessageModel.create!(chat_model_id: @chat.id, number: message_number, body: body)
  end
end
