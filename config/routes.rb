Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  put '/games/move/:direction', to: "games#move"
  post '/games/start', to: "games#start"

  root "games#play"
end
