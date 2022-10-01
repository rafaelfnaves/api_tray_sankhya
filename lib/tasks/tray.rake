namespace :tray do
  desc "Criar Produtos na Tray"
  task create_products: :environment do
    begin
      # Authentication
      url_auth = "#{ENV['API_ADDRESS']}/auth"
      response = RestClient.post url_auth, {consumer_key: ENV['CONSUMER_KEY'], consumer_secret: ENV['CONSUMER_SECRET'], code: ENV['CODE']}
      hash = JSON.parse(response.body)
      
      binding.pry
      
      # Save or Update products in Tray
      Product.send_tray!(hash["access_token"])
    rescue Exception => e
      puts "Error: #{response.code} => {#{response.body}}"
    end
  end
end