WineCrawl::Application.routes.draw do
  resources :wines, only: [:index, :show]
  #resources :wine_price_histories
  devise_for :admin_users, ActiveAdmin::Devise.config

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
  ActiveAdmin.routes(self)
end
