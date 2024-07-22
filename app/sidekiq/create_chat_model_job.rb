class CreateChatModelJob
  include Sidekiq::Job

  def perform(application_token, chat_number)
    @application_model = ApplicationModel.find_by!(token: application_token)
    ApplicationModel.transaction do
      @application_model = ApplicationModel.lock.first
      @application_model.chats_count = chat_number
      @application_model.save!
    end
    ChatModel.create!(application_model_id: application_token, number: chat_number)
  end
end
