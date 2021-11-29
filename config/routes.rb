Rails.application.routes.draw do
  root 'albums#index'

  namespace :albums do
    resources :labels, only: %i[index show]
  end

  resources :albums, only: %i[index show] do
    member do
      patch :put_label, :remove_label
    end
  end

  resources :artists, only: %i[index show]

  resources :playlists, only: %i[index show]
end
