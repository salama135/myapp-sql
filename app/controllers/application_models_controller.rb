class ApplicationModelsController < ApplicationController
  before_action :set_application, only: [:show, :update]
  before_action :create_token, only: [:create] # Generate the token when the application is created
  
  # GET /applications/
  def index
    @applications = ApplicationModel.all
    render json: @applications
  end

  # GET /applications/:token
  def show
    render json: @application
  end

  # POST /applications
  def create
    @application = ApplicationModel.new(token: @token, name: application_params[:name], chats_count: 0)
    if @application.save
      render json: @application, status: :created
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # PUT /applications/:token
  def update
    if @application.update(application_params)
      render json: @application
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  private

  def create_token
    loop do
      @token = SecureRandom.uuid # Use SecureRandom for stronger tokens
      break @token unless ApplicationModel.exists?(token: @token)
    end
  end

  def set_application
    @application = ApplicationModel.find_by!(token: params[:token])
  end

  def application_params
    params.require(:application).permit(:name)
  end
end