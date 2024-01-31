namespace :snk do
  desc "Authenticate on SNK and GET Products on VIEW"
  task create_products: :environment do
    start_time = Time.now

    begin
      products = Product.view_snk!("VGFSLL")
      Product.save_product!(products)
    rescue Exception => e
      puts "Erro ao salvar produtos: #{e.message}"
    end

    puts "snk:create_products\n
          start at #{start_time}\n
          Finish at #{Time.now}"
  end

  desc "Get price and stock on SNK VIEW"
  task stock_price: :environment do
    start_time = Time.now

    begin
      products = Product.view_snk!("VGFESTPRICE")
    rescue Exception => e
      puts "[ERROR] Consultar view de stock e preco #{e.message}"
    end

    active_products = products.select{ |i| i["ativo"] == "S" }
    active_products.each do |item|
      product = Product.find_by_sku(item["sku"])
      unless product.nil?
        product.update(
          price: item["preco_cheio"].to_f,
          stock: item["estoque_quantidade"].blank? ? nil : item["estoque_quantidade"].to_i
        )

        begin
          Product.stock_price_tray!(product.id_tray, product.price, product.stock)
        rescue Exception => e
          puts "[ERROR stock_price_tray] Product: #{product.id} -> #{e.message}"
        end
      end
    end

    puts "snk:stock_price\n
          start at #{start_time}\n
          Finish at #{Time.now}"
  end
end