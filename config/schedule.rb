set :environment, 'production'

every :day, at: ["06:00 AM", "02:00 PM"] do
  rake "db:update_products"
end

every 3.minutes do
  rake 'snk:stock_price'
end

every 7.minutes do
  rake 'tray:update_products'
end
