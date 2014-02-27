WineCrawl::Application.routes.draw do
  match '/search' => 'wine_monitors#search'#, defaults: {page: 1}
  authenticated :user do
    root :to => 'wine_monitors#index'
    scope module: 'user' do
      resources :wine_links
    end
  end
  resources :wine_links
  resources :user_monitors
  resources :comments, only: [:index, :show, :create]
  get '/go/:lib/:id' => 'wine_monitors#links',as: :go
  post '/go/:lib/:id' => 'wine_monitors#links',as: :go
  resources :wine_monitors, only: [:index, :show, :new, :create] do
    resources :comments, only: [:index,:create]
    get 'category/:id' => 'wine_monitors#category', on: :collection, as: 'category'
    get 'categories' => 'wine_monitors#categories', on: :collection, as: 'categories'
    #collection do
      #match :search
    #end
  end
  resources :wines, only: [:index, :show] do
    resources :comments, only: [:index,:create]
  end
  #resources :wine_price_histories
  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "wine_monitors#index"

  devise_for :users, controllers: {
    omniauth_callbacks: :authentications,
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  ActiveAdmin.routes(self)
end
