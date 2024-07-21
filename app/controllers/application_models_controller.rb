class ApplicationModelsController < ApplicationController
  before_action :set_application, only: [:show, :update, :chats]
  before_action :create_application_model_token, only: [:create] # Generate the token when the application is created

  def index
    @application_models = ApplicationModel.all
    render json: @application_models
  end

  # GET /application_models/:token
  def show
    @application_model = ApplicationModel.find(params[:id])
    render json: @application_model
  end

  # POST /application_models
  def create
    @application = ApplicationModel.new(token: @application_model_token, name: application_params[:name], chats_count: 0)
    if @application.save
      render json: @application, status: :created
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end
  
  private

  def create_application_model_token
    loop do
      @application_model_token = SecureRandom.uuid # Use SecureRandom for stronger tokens
      break @application_model_token unless ApplicationModel.exists?(token: @application_model_token)
    end
  end

  def application_params
    params.require(:application_model).permit(:name)
  end
end