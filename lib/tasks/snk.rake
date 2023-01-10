namespace :snk do
  desc "Authenticate on SNK and GET Products on VIEW"
  task create_products: :environment do
    puts "Start snk:products"

    begin
      jsessionid = Auth.jsessionid!()
      products = Product.view_snk!("VGFSLL", jsessionid)
      Product.save_product!(products)
    rescue Exception => e
      puts "Erro ao salvar produtos: #{e.message}"
      Honeybadger.notify("Erro ao salvar produtos: #{e.message}")
    end

    Rails.logger.info "Task snk:create_products done."
    puts "End snk:products"
  end

  desc "Get price and stock on SNK VIEW"
  task stock_price: :environment do
    puts "Start snk:stock_price"

    begin
      jsessionid = Auth.jsessionid!()
      products = Product.view_snk!("VGFESTPRICE", jsessionid)
      for item in products
        product = Product.find_by_sku(item["sku"])
        unless product.nil?
          product.update_column(:active, item["ativo"])
          product.update_column(:stock, item["estoque_quantidade"].nil? ? nil : item["estoque_quantidade"].to_i)
          product.update_column(:price, item["preco_cheio"].to_f)
          begin
            Product.stock_price_tray!(product.id)
          rescue Exception => e
            Honeybadger.notify("Erro ao atualizar Estoque e Preço do produto SKU #{product.sku} na Tray: #{e.message}")        
          end
        end
      end
    rescue Exception => e
      puts "Erro ao atualizar Estoque e Preço do produto: #{e}"
      Honeybadger.notify("Erro ao atualizar Estoque e Preço do produto: #{e.message}")
    end
    Rails.logger.info "Task snk:stock_price done."
    puts "End snk:stock_price"
  end
end