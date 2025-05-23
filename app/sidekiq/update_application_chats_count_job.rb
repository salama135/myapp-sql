class UpdateApplicationChatsCountJob
  include Sidekiq::Job

  def perform
    ApplicationModel.find_each do |application|
      actual_chats_count = application.chat_models.count
      application.update(chats_count: actual_chats_count)
    end
  end
end
