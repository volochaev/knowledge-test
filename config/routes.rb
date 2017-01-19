Rails.application.routes.draw do
  resources :posts, only: [:index, :create] do
    collection do
      get :popular
      get :ips
    end

    member do
      resource :vote, only: :update
    end
  end
end
