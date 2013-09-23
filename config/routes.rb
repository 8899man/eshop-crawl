WineCrawl::Application.routes.draw do
  get '/go/:id' => 'wines#links',as: :go
  resources :wines, only: [:index, :show]
  #resources :wine_price_histories
  devise_for :admin_users, ActiveAdmin::Devise.config

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "wines#index"
  devise_for :users
  resources :users
  ActiveAdmin.routes(self)
end
