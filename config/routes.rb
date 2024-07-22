Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "/application_models", to: "application_models#index"
  get "/application_models/:token", to: "application_models#show"
  post "/application_models", to: "application_models#create"
  put "/application_models/:token", to: "application_models#update"

  post "/chat_models/:application_token/chats", to: "chat_models#create"
  get "/chat_models/:application_token/chats", to: "chat_models#index"
  get "/chat_models/:application_token/chats/:number", to: "chat_models#show"
  get "/chat_models/:application_token/chats/:number/messages", to: "chat_models#messages"

  # resources :application_models, only: [:index, :show, :create, :update] do
  #   resources :chat_models, only: [:create, :show] do
  #     resources :message_models, only: [:create, :show] do
  #       collection do 
  #         get 'search'
  #       end
  #     end
  #   end
  # end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
