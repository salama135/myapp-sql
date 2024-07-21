class ApplicationModelsController < ApplicationController
  before_action :set_application, only: [:show, :update, :chats]
  before_action :create_application_model_token, only: [:create] # Generate the token when the application is created
  
  # GET /application_models/
  def index
    @application_models = ApplicationModel.all
    render json: @application_models
  end

  # GET /application_models/:token
  def show
    render json: @application_model
  end

  # POST /application_models
  def create
    @application_model = ApplicationModel.new(token: @application_model_token, name: application_params[:name], chats_count: 0)
    if @application_model.save
      render json: @application_model, status: :created
    else
      render json: @application_model.errors, status: :unprocessable_entity
    end
  end

  # PUT /application_models/:token
  def update
    if @application_model.update(application_params)
      render json: @application_model
    else
      render json: @application_model.errors, status: :unprocessable_entity
    end
  end

  # GET /application_models/:token/chats
  def chats
    chats = @application_model.chats.order(number: :asc)
    render json: chats
  end

  private

  def create_application_model_token
    loop do
      @application_model_token = SecureRandom.uuid # Use SecureRandom for stronger tokens
      break @application_model_token unless ApplicationModel.exists?(token: @application_model_token)
    end
  end

  def set_application
    @application_model = ApplicationModel.find_by!(token: params[:id])
  end

  def application_params
    params.require(:application_model).permit(:name)
  end
end