Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      patch :vote_for
      patch :vote_against
      patch :vote_back
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, concerns: [:votable], except: [:index, :update, :new], shallow: true do
      patch :set_best, on: :member
    end
  end

  resources :answers, only: [:update, :destroy]
  resources :attachments, only: [:destroy]
end
