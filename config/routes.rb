Rails.application.routes.draw do
  root 'welcome#index'

  get 'welcome/index'

  namespace :albums do
    resources :labels, only: %i[index show edit] do
      member do
        patch :add_album, :remove_album
      end
    end
  end

  resources :albums, only: %i[index show] do
    member do
      patch :put_label, :remove_label
    end
  end

  resources :artists, only: %i[index show]

  resources :playlists, only: %i[index show]
end
