class ApplicationModelsController < ApplicationController
  def index
    @application_models = ApplicationModel.all
  end
end
