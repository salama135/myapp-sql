class CreateMessageModelJob
  include Sidekiq::Job

  def perform(application_token, chat_identifier_number, message_number, body)
    @application = ApplicationModel.find_by!(token: application_token)
    # chat_identifier_number is used to find the parent chat
    @chat = @application.chat_models.find_by!(number: chat_identifier_number) 
    
    # The message_number is now provided by the controller (originating from Redis)
    MessageModel.create!(
      chat_model_id: @chat.id,
      number: message_number,
      body: body
    )
  end
end
