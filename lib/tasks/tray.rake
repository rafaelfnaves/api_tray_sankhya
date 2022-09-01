namespace :tray do
  desc "Criar Produtos na Tray"
  task create_products: :environment do
    begin
      # Authentication
      puts "Inicio de integração via API com a Tray para cadastro de produtos"

      url_auth = "#{ENV['API_ADDRESS']}/auth"
      puts "Autênticação: #{url_auth}"

      response = RestClient.post url_auth, {consumer_key: ENV['CONSUMER_KEY'], consumer_secret: ENV['CONSUMER_SECRET'], code: ENV['CODE']}
      puts "Resposta de requisição de Autênticação:"
      puts "Response: #{response}"
      puts "Status: #{response.code}"
      puts "Corpo da resposta: #{response.body}"

      hash = JSON.parse(response.body)
      Product.send_tray!(hash["access_token"])
    rescue Exception => e
      puts "Error: #{response.code} => {#{response.body}}"
    end
  end
end