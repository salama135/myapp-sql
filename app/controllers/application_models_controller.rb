class ApplicationModelsController < ApplicationController
  def index
    @application_models = ApplicationModel.all
  end

  def show
    @application_model = ApplicationModel.find(params[:id])
  end
end
