require 'redis'

class MessageModelsController < ApplicationController
	before_action :set_application, only: [:create, :search] # Added :search
	before_action :set_chat, only: [:create, :search] # Added :search
	before_action :set_message, only: [:show]
	
	# POST /applications/:token/chats/:number/messages
  def create
    # @application and @chat are set by before_actions
    redis_url = ENV['REDIS_URL'] || 'redis://localhost:6379/0'
    redis = Redis.new(url: redis_url)
    
    # Construct the Redis key using both application token and chat number
    message_number = redis.incr("application:\#{@application.token}:chat:\#{@chat.number}:message_number")
    
    CreateMessageModelJob.perform_async(params[:token], @chat.number, message_number, params[:body])
    render json: { number: message_number }, status: :created
  end
  
	# GET /applications/:token/chats/:number/messages/:message_number
	def show
		render json: message.as_json(), status: :ok
	end
	
  # GET /applications/:token/chats/:number/messages/search
	def search
    query = params["query"] || ""
    # @chat is now set by before_action
    res = MessageModel.search(query, @chat.id)
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
