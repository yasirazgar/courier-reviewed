Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :v1, :format => true, :constraints => { :format => 'json' } do
    post "login", to: "authentication#create", as: "login"

    resources :restaurants, only: [:index, :show] do
      resources :couriers, only: [] do
        member do
          patch :assign
          patch :unassign
        end
      end
    end

    namespace :admin do
      resources :users, only: :create
      resources :restaurants, only: [:index, :create, :update, :destroy]
    end
  end
end
