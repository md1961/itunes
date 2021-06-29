Rails.application.routes.draw do
  get 'artists/index'
  root 'albums#index'

  resources :albums, only: %i[index show]
end
