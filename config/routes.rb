Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, except: [:index, :update, :new], shallow: true do
      patch :set_best, on: :member
    end
  end

  resources :answers, only: [:update, :destroy]
end
