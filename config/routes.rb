Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  put '/games/move/:direction', to: "games#move"
  post '/games/start', to: "games#start"

  resources :games, only: [:show, :index] do
    member do
      get :join
      put 'move/:direction', to: 'games#move'
    end
  end

  root "games#index"
end
