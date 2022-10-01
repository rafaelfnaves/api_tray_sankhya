Rails.application.routes.draw do
  post '/hooks', to: 'hooks#order_callback'
end
