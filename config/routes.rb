Rails.application.routes.draw do
  post '/hooks', to: 'hooks#order_callback'

  namespace :api do
    namespace :v1 do
      resources :products, only: [:index, :show]
      resources :orders, only: [:index, :show]
    end
  end
end
