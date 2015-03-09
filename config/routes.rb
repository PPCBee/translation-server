Rails.application.routes.draw do

  resources :releases, except: [:edit, :update]

  resources :imports, only: [:index, :create]

  resources :highlights

  resources :translates, only: :index do
    collection do
      get 'browse/*key_path' => 'translates#index', as: :browse
      get 'hint' => 'translates#hint', as: :hint
    end
  end
  post '/translates' => 'translates#index'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :images,       only: :create
      resources :translations, only: [:index, :create]
      resources :releases,     only: [:index, :show]
      match 'releases',     to: 'releases#index_head',     via: [:head]
      match 'releases/:id', to: 'releases#show_head',      via: [:head]
      match 'translations', to: 'translations#index_head', via: [:head]
    end
  end

  resources :images do
    get :display, on: :member
  end

  resources :locations

  resources :keys

  resources :locales

  resources :translations

  devise_for :users
  resources :users

  resource :developer

  root to: 'root#index'
end
