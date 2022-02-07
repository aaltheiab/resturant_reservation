Rails.application.routes.draw do
  resources :users, param: :employee_number
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # post '/auth/login', to: 'authentication#login'

  resources :auth, only: [] do
    collection do
      post :login
    end
  end

  resources :tables, only: [:index, :create, :update, :destroy]
  resources :reservations, only: [:index, :destroy] do
    collection do
      get :availability
      get :today
    end
  end
end
