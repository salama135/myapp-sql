class CreateChatModelJob
  include Sidekiq::Job

  def perform(application_token, chat_number)
    @application = ApplicationModel.find_by!(token: application_token)
    
    # The chat_number is now provided by the controller (originating from Redis)
    ChatModel.create!(
      application_model_id: @application.id,
      number: chat_number,
      messages_count: 0 # Initialize messages_count
    )
  end
end
