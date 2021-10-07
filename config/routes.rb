Rails.application.routes.draw do
  root 'albums#index'

  resources :albums, only: %i[index show]

  resources :artists, only: %i[index show]
end
