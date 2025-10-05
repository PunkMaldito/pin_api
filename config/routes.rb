Rails.application.routes.draw do
  health_check = proc { [ 200, { "Content-Type" => "application/json" }, [ { status: "OK" }.to_json ] ] }
  get "up", to: ->(env) { health_check.call(env) }
  get "health", to: "health#show"

  namespace :api do
    namespace :v1 do
      post "auth/login", to: "auth#login"
      post "auth/signup", to: "auth#signup"

      resources :products do
        member do
          post :sell
          post :build
        end

        collection do
          get :low_stock
          get :out_of_stock
        end
      end
    end
  end

  match "*path", to: ->(env) {
    [ 404, { "Content-Type" => "application/json" }, [ { error: "Route not found" }.to_json ] ]
  }, via: :all
end
