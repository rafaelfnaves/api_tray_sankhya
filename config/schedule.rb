set :environment, 'production'
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

every :day, at: ["06:00 AM", "02:00 PM"] do
  rake "db:update_products"
end

every 3.minutes do
  rake 'snk:stock_price'
end

every 7.minutes do
  rake 'tray:update_products'
end

every 10.minutes do
  rake 'tray:get_orders'
end