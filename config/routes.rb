# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  put '/games/move/:direction', to: 'games#move'
  post '/games/start', to: 'games#start'

  resources :story, only: %i[index show]
  resources :games, only: %i[show index create] do
    member do
      get :join
      put 'move/:direction', to: 'games#move'
    end
  end

  root 'home#index'
end
