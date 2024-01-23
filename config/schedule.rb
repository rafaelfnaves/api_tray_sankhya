set :output, '/var/log/cron.log' # log location

every 2.hours do
  rake "db:update_products"
end

every 15.minutes do
  rake 'snk:stock_price'
end

every 10.minutes do
  rake 'tray:get_orders'
end