class CreateChatModelJob
  include Sidekiq::Job

  def perform(application_token, chat_number)
    @application = ApplicationModel.find_by!(token: application_token)
    ApplicationModel.transaction do
      @application = ApplicationModel.lock.first
      @application.chats_count = chat_number
      @application.save!
    end
    ChatModel.create!(application_model_id: @application.id, number: chat_number, messages_count: 0)
  end
end
