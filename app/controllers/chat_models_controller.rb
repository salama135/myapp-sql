class ChatModelsController < ApplicationController
  before_action :set_application
  before_action :set_chat, only: [:show, :messages]

  # POST /applications/:token/chats
  def create
    chat_number = @application.chats_count + 1
    CreateChatModelJob.perform_async(params[:token], chat_number)
    render json: { "number": chat_number }, status: :ok
  end
  
  # GET /applications/:token/chats
  def index
    render json: @application.chat_models.as_json(), status: :ok
  end

  # GET /applications/:token/chats/:number
  def show
    render json: @chat.as_json(), status: :ok
  end

  # GET /applications/:token/chats/:number/messages
  def messages
    messages = @chat.message_models.order(number: :asc)
    render json: messages
  end

  private

  def set_application
    @application = ApplicationModel.find_by!(token: params[:token])
  end

  def set_chat
    @chat = @application.chat_models.find_by!(number: params[:number])
  end
end
