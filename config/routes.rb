Rails.application.routes.draw do
  devise_for :users
  resources :boards
# root 'posts#index'
  root 'boards#index'
end
