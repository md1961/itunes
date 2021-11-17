Rails.application.routes.draw do
  root 'albums#index'

  resources :albums, only: %i[index show] do
    member do
      patch :put_label, :remove_label
    end
  end

  resources :artists, only: %i[index show]

  resources :playlists, only: %i[index show]
end
