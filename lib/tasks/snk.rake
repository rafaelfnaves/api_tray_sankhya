namespace :snk do
  desc "Authenticate on SNK and GET Products on VIEW"
  task create_products: :environment do
    puts "Start snk:products"

    jsessionid = Product.login_snk!()
    begin
      products = Product.view_snk!("VGFSLL", jsessionid)
      Product.save_product!(products)
    rescue Exception => e
      puts "Erro ao salvar produtos."
    end

    puts "End snk:products"
  end

  desc "Get price and stock on SNK VIEW"
  task stock_price: :environment do
    puts "Start snk:stock_price"

    response = Product.login_snk!(ENV["LOGIN_URL_SNK"])
    if response.code == 200
      hash = JSON.parse(response.body)
      begin
        jsessionid = hash["responseBody"]["jsessionid"]["$"]
        products = Product.view_snk!("VGFESTPRICE", jsessionid)
        for item in products
          product = Product.find_by_sku(item["sku"])
          unless product.nil?
            product.update_column(:active, item["ativo"])
            product.update_column(:stock, item["estoque_quantidade"].nil? ? nil : item["estoque_quantidade"].to_i)
            product.update_column(:price, item["preco_cheio"].to_f)
          end
        end
      rescue Exception => e
        puts "Erro ao atualizar Estoque e Preço do produto: #{e}"
      end
    end
    
    puts "End snk:stock_price"
  end
end