set :output, '/var/log/cron.log' # log location

every :day, at: ["07:00 AM", "02:00 PM", "08:00 PM"] do
  rake "db:update_products"
end

every 5.minutes do
  rake 'snk:stock_price'
end

every 5.minutes do
  rake 'tray:get_orders'
end