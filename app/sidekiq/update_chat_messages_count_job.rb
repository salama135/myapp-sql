class UpdateChatMessagesCountJob
  include Sidekiq::Job

  def perform
    ChatModel.find_each do |chat|
      actual_messages_count = chat.message_models.count
      chat.update(messages_count: actual_messages_count)
    end
  end
end
