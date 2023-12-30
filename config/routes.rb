Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  put '/games/move/:direction', to: "games#move"

  root "games#play"
end
