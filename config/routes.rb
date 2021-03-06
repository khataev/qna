require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, -> (u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
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
    resources :subscriptions, only: [:create, :destroy], shallow: true
  end

  resources :answers, only: [:update, :destroy]
  resources :attachments, only: :destroy

  # search
  get '/search', to: 'search#show'

  # API
  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :all_but_me, on: :collection
      end

      resources :questions do
        resources :answers, shallow: true
      end
    end
  end
end
