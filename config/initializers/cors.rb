Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '/hooks', headers: :any, methods: :post
  end
end