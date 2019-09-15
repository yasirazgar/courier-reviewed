Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :v1, :format => true, :constraints => { :format => 'json' } do
    post "login", to: "authentication#create", as: "login"

    namespace :admin do
      resources :users, only: :create
    end
  end
end
