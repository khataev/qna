Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    patch :vote_for, on: :member
    patch :vote_against, on: :member
    patch :vote_back, on: :member

    resources :answers, except: [:index, :update, :new], shallow: true do
      patch :set_best, on: :member
    end
  end

  resources :answers, only: [:update, :destroy]
  resources :attachments, only: [:destroy]
end
