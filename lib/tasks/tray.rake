namespace :tray do
  desc "Criar Produtos na Tray"
  task create_products: :environment do
    begin
      # Save or Update products in Tray
      Product.send_tray!(Auth.access_token!())
    rescue Exception => e
      puts "Error: #{response.code} => {#{response.body}}"
    end
  end

  desc "Busca os produtos cadastrados na Tray"
  task get_products: :environment do
    url = "#{ENV['API_ADDRESS']}/products"
    response = RestClient.get url
    hash = JSON.parse(response.body)
    prds = []
    hash["Products"].each do |product|
      i = Product.find_by_name(product["Product"]["name"])
      unless i.nil?
        i.update_column(:id_tray, product["Product"]["id"])
        prds << i.id_tray
      end
    end
    puts prds
  end
end