Rails.application.routes.draw do
  resources :questions, except: [:show] do
    resources :answers, except: [:update, :destroy, :new]
  end

  resources :answers, only: [:update, :destroy]
end
