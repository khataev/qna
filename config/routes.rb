Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, except: [:index, :update, :new], shallow: true
  end

  resources :answers, only: [:update, :destroy]
end
