Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "auth/login", to: "auth#login"

      resources :products do
        member do
          post :sell
          post :build
        end
      end
    end
  end
end
