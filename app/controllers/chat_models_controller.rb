class ChatModelsController < ApplicationController
  before_action :set_application, only: [:index, :create]
  before_action :set_chat, only: [:show, :messages]

  # POST /chat_models/:application_token/chats
  def create
    chat_number = @application.chats_count + 1
    CreateChatModelJob.perform_async(params[:application_token], chat_number)
    render json: { "number": chat_number }, status: :ok
  end
  
  # GET /chat_models/:application_token/chats
  def index
    render json: @application.chat_models.as_json(), status: :ok
  end

  # GET /chat_models/:application_token/chats/:number
  def show
    render json: chat.as_json(only: :number), status: :ok
  end

  # GET /chat_models/:application_token/chats/:number/messages
  def messages
    messages = @chat.messages.order(number: :asc)
    render json: messages
  end

  private

  def set_application
    @application = ApplicationModel.find_by!(token: params[:application_token])
  end

  def set_chat
    p params
    @chat = @application.chat_models.find_by!(number: params[:application_token])
  end
end
