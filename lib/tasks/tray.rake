namespace :tray do
  desc "Criar Produtos na Tray"
  task create_products: :environment do
    begin
      # Save or Update products in Tray
      Product.send_tray!
    rescue Exception => e
      puts "Error create products on tray: #{e.message}"
      Honeybadger.notify("Error create products on tray: #{e.message}")
    end
    Rails.logger.info "Task tray:create_products done."
  end

  desc "Busca os produtos cadastrados na Tray"
  task get_products: :environment do
    Product.all.each do |i|
      unless i.sku.nil?
        begin
          sleep 2
          
          url = "#{ENV['API_ADDRESS']}/products"
          response = RestClient.get url, {params: {'reference' => i.sku.to_s}}
          hash = JSON.parse(response.body)

          product = hash["Products"].first["Product"]
          i.id_tray = product["id"]
          i.category = product["category_id"]
          i.save!

          puts "Atualizado produto - id_tray: #{i.id_tray} | category: #{i.category}"

          Rails.logger.info "Task tray:get_products ok. id_tray: #{i.id_tray} | category: #{i.category}"
        rescue Exception => e
          puts "Erro ao consultar produto id: #{i.id} - ERROR #{e.message}"
          Honeybadger.notify("Erro ao consultar produto id: #{i.id} - ERROR #{e.message}")

          Rails.logger.info "Task tray:get_products error. id_tray: #{i.id_tray} | category: #{i.category}"
        end
      end
    end
  end

  task update_products: :environment do
    Rake::Task["tray:get_products"].invoke
    Rake::Task["tray:create_products"].invoke
  end

  desc "Deleta os produtos informados na Tray"
  task delete_products: :environment do
    xls = Roo::Spreadsheet.open("#{Rails.root}/inativos.xls")
    skus = xls.column(2)
    skus.delete_at(0)
    
    token = Auth.access_token!()

    count = 0

    skus.each do |i|
      product = Product.find_by_sku(i.to_i.to_s)
      unless product.nil? || product.id_tray.nil? #verificar antes o id_tray
        url = "#{ENV['API_ADDRESS']}/products/#{product.id_tray}/?access_token=#{token}"
        
        # binding.pry
        begin
          response = RestClient.delete url
          puts response.body
          
          product.destroy
        rescue Exception => e
          puts "Erro ao fazer requisição: #{url}"
        end

      end
      count += 1
      puts count
    end
  end

  desc "Get orders on tray"
  task get_orders: :environment do
    puts "Start task tray:get_orders"

    begin
      today = Date.today.to_s
      
      url = "#{ENV['API_ADDRESS']}/orders?access_token=#{Auth.access_token!()}&has_payment=1&date=#{today}"
      
      response = RestClient.get url
      
      hash = JSON.parse(response.body)
      
      unless hash["paging"]["total"] == 0
        pages = (hash["paging"]["total"].to_f / hash["paging"]["limit"].to_f).ceil # round to UP
        page_now = 1

        while page_now <= pages
          
          url = "#{ENV['API_ADDRESS']}/orders?access_token=#{Auth.access_token!()}&has_payment=1&date=#{today}&page=#{page_now}"
          response = RestClient.get url
          hash = JSON.parse(response.body)
          hash["Orders"].each do |i|
            Order.get_order!(i["Order"]["id"])
          end
          
          page_now += 1
        end
      end
    rescue Exception => error
      puts "Error task for consult today orders on tray. Time: #{Time.now}, Error: #{error.message}"
      Honeybadger.notify("Error task for consult today orders on tray. Time: #{Time.now}, Error: #{error.message}")
      Rails.logger.info "Error task for consult today orders on tray. Time: #{Time.now}, Error: #{error.message}"
    end

    puts "End task tray:get_orders"
  end
end

