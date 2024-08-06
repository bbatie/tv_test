# config/routes.rb
Rails.application.routes.draw do
  devise_for :users
  root to: "playlists#index"
  get "playlists/show", to: "playlists#show", as: "playlist_show"
  resources :playlists, only: [:index]
end
