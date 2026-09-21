# frozen_string_literal: true

require 'sidekiq/web'

Fabularr::Application.routes.draw do
  mount Sidekiq::Web => '/sidekiq' # http://localhost:3000/sidekiq

  root to: 'static_pages#home'

  scope '(:locale)', locale: /pl|en/ do
    resources :animals, only: [] do
      get :attack, on: :collection
    end
    resources :characters, only: %i[new create show] do
      get :attack
      get :name
      get :set
      get :talk
    end
    resources :char_names
    resources :events
    resources :inventory_objects, only: %i[index create update] do
      get :add
      get :drop
      get :drop_item
      get :eat
      post :eat, on: :collection, to: 'inventory_objects#consume'
    end
    resources :location_names, only: %i[create]
    resources :location_objects, only: [:create] do
      get :take
      get :take_item
    end
    resources :location_resources, only: [] do
      get :new, on: :collection, as: :discover
    end
    resources :locations do
      get :enter
      get :name
      get :examine, on: :collection
    end
    resources :maps, only: :index
    resources :projects, only: %i[create destroy show] do
      get :join
      get :leave
      scope path: 'new', as: :new, to: 'projects#new' do
        get 'build/:recipe_id',
            as: :build, on: :collection, defaults: { type: 'build' }
        get 'collect/:location_resource_id',
            as: :collect, on: :collection, defaults: { type: 'collect' }
        get 'road/:location_id',
            as: :road, on: :collection, defaults: { type: 'road' }
        post 'machine',
             as: :machine, on: :collection, defaults: { type: 'machine' }
      end
    end
    resources :recipes, only: [:index] do
      get 'machine/:id', to: 'recipes#machine', as: :machine, on: :collection
    end
    resources :sessions, only: %i[new create destroy]
    resources :travellers, only: %i[new create update] do
      get :stop
      get :reverse
    end
    resources :users, only: %i[create edit update]

    match '/register', to: 'users#new', via: 'get'
    match '/login', to: 'sessions#new', via: 'get'
    match '/logout', to: 'sessions#destroy', via: 'delete'
    match '/list', to: 'users#show', via: 'get'
    match '/attack', to: 'attacks#create', via: 'post'

    scope path: 'point', controller: 'events', action: 'point' do
      get 'character/:id', as: :point_character, defaults: { type: 'character' }
    end

    namespace :api do
      resources :events, only: :show do
        get :unread, on: :collection
      end
      resources :characters, only: [] do
        get :name
      end
    end
  end

  namespace :admin do
    get '/', to: 'index#index'

    resources :characters
    resources :locations
  end
end
