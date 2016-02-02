Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, except: [:show] do
    resources :answers, except: [:update, :new], shallow: true
  end

  resources :answers, only: [:update, :destroy]
end
