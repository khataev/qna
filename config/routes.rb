Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: 'questions#index'

  devise_scope :user do
    post 'omniauth_callbacks/send_confirmation_email'
  end

  concern :votable do
    member do
      patch :vote_for
      patch :vote_against
      patch :vote_back
    end
  end

  concern :commentable do
    resources :comments, only: [:create], shallow: true
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], only: [:create, :edit], shallow: true do
      patch :set_best, on: :member
    end
  end

  resources :answers, only: [:update, :destroy]
  resources :attachments, only: [:destroy]
end
