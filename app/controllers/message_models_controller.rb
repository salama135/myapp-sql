class MessageModelsController < ApplicationController
	before_action :set_application, only: [:create]
	before_action :set_chat, only: [:create]
	before_action :set_message, only: [:show]
	
	# POST /applications/:token/chats/:number/messages
  def create
    chat_number = @chat.number
    message_number = @chat.messages_count + 1
    CreateMessageModelJob.perform_async(params[:token], chat_number, message_number, params[:body])
    render json: { "number": message_number }, status: :ok
  end
  
	# GET /applications/:token/chats/:number/messages/:message_number
	def show
		render json: message.as_json(), status: :ok
	end
	
  # GET /applications/:token/chats/:number/messages/search
	def search
    query = params["query"] || ""
    res = MessageModel.search(query)
    p "res: #{res}"
    render json: res.response["hits"]["hits"]
	end

	private

  def set_application
    @application = ApplicationModel.find_by!(token: params[:token])
  end

  def set_chat
    @chat = @application.chat_models.find_by!(number: params[:number])
  end

	def set_message
    @message = @chat.message_models.find_by!(number: params[:message_number])
  end
end
