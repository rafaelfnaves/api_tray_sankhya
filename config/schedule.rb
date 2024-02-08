# log location global
# set :output, 'log/cron.log' 

every 2.hours do
  rake 'db:update_products', output: 'log/update-products-cron.log'
end

every 15.minutes do
  rake 'snk:stock_price', output: 'log/stock-price-cron.log'
end

every 5.minutes do
  rake 'tray:get_orders', output: 'log/orders-cron.log'
end