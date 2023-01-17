class Product < ApplicationRecord
  validates_uniqueness_of :sku, on: :create, message: "SKU já existe."

  def self.save_product!(products)
    
    products.each do |product|      
      data = Product.find_by_sku(product["sku"])
      if data.nil?
        product = self.create!(
          sku: product["sku"], 
          active: product["ativo"], 
          price: product["preco_cheio"].to_f,
          cost: product["preco_custo"].to_f,
          ncm: product["ncm"],
          name: product["nome"],
          description: product["descricao_completa"],
          stock: product["estoque_quantidade"].nil? ? nil : product["estoque_quantidade"].to_i,
          brand: product["marca"],
          weight: product["peso_em_kg"].nil? || product["peso_em_kg"] == 0 || product["peso_em_kg"] == "0" || product["peso_em_kg"].blank? ? 1 : product["peso_em_kg"].to_i,
          height: product["altura_em_cm"].nil? ? nil : product["altura_em_cm"].to_i,
          width: product["largura_em_cm"].nil? ? nil : product["largura_em_cm"].to_i,
          length: product["comprimento_em_cm"].nil? ? nil : product["comprimento_em_cm"].to_i,
          volume: product["codvol"]
        )

        Product.create_tray!(product)
      else
        data.update_column(:active, product["ativo"])
        data.update_column(:price, product["preco_cheio"].to_f)
        data.update_column(:cost, product["preco_custo"].to_f)
        data.update_column(:ncm, product["ncm"])
        data.update_column(:name, product["nome"])
        data.update_column(:description, product["descricao_completa"])
        data.update_column(:stock, product["estoque_quantidade"].nil? ? nil : product["estoque_quantidade"].to_i)
        data.update_column(:brand, product["marca"])
        data.update_column(:weight, product["peso_em_kg"].nil? || product["peso_em_kg"] == 0 || product["peso_em_kg"] == "0" || product["peso_em_kg"].blank? ? 1 : product["peso_em_kg"].to_i)
        data.update_column(:height, product["altura_em_cm"].nil? ? nil : product["altura_em_cm"].to_i)
        data.update_column(:width, product["largura_em_cm"].nil? ? nil : product["largura_em_cm"].to_i)
        data.update_column(:length, product["comprimento_em_cm"].nil? ? nil : product["comprimento_em_cm"].to_i)
        data.update_column(:volume, product["codvol"])

        Product.get_tray!(data.id)
        Product.update_tray!(data.id)
      end
    end
  end

  def self.create_tray!(product)
    sleep 2
    
    begin
      access_token = Auth.access_token!()
      
      url = URI("#{ENV['API_ADDRESS']}/products?access_token=#{access_token}")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request.body = Product.request_body!(product)
      
      response = https.request(request)
      hash = JSON.parse(response.body)
      
      product.id_tray = hash["id"]
      product.save!

      puts "Produto (SKU: #{product.sku}) Criado na Tray."
    rescue Exception => e
      puts "Erro ao enviar produto (SKU: #{product.sku}) para a Tray: #{e.message}"
      Honeybadger.notify("Erro ao enviar produto (SKU: #{product.sku}) para a Tray: #{e.message}")
    end
  end

  # Get info product on tray
  def self.get_tray!(id)
    product = Product.find(id)
    
    begin
      url = "#{ENV['API_ADDRESS']}/products"
      response = RestClient.get url, {params: {'reference' => product.sku.to_s}}
      hash = JSON.parse(response.body)

      hash_product = hash["Products"].first["Product"]
      product.id_tray = hash_product["id"]
      product.category = hash_product["category_id"]
      product.save!

      puts "Atualizado produto - id_tray: #{product.id_tray} | category: #{product.category}"
      Rails.logger.info "Task tray:get_products ok. id_tray: #{product.id_tray} | category: #{product.category}"
    rescue Exception => e
      puts "Erro ao consultar produto SKU: #{product.sku} - ERROR #{e.message}"
      Honeybadger.notify("Erro ao consultar produto SKU: #{product.sku} - ERROR #{e.message}")
    end
  end
  

  def self.update_tray!(id)
    product = Product.find(id)

    sleep 2

    begin
      access_token = Auth.access_token!()
      url = URI("#{ENV['API_ADDRESS']}/products/#{product.id_tray}?access_token=#{access_token}")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Put.new(url)
      request["Content-Type"] = "application/json"
      request.body = Product.request_body!(product)
      response = https.request(request)
      
      if response.code == 200 || response.code == "200"
        puts "Produto ID_TRAY: #{product.id_tray} atualizado na Tray"
      else
        puts "[ERROR] -> Erro ao atualizar Produto ID_TRAY: #{product.id_tray} na Tray. Response: #{response.code} - #{response.body}"
      end
    rescue Exception => e
      puts "Não possível atualizar o produto (ID: #{product.id_tray}) na Tray. Erro: #{e.message}"
      Honeybadger.notify("Não possível atualizar o produto (ID: #{product.id_tray}) na Tray. Erro: #{e.message}")
    end
  end
  

  def self.stock_price_tray!(id)
    sleep 2
    
    product = Product.find(id)

    access_token = Auth.access_token!()

    url = URI("#{ENV['API_ADDRESS']}/products/#{product.id_tray}?access_token=#{access_token}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Put.new(url)
    request["Content-Type"] = "application/json"
    request.body = JSON.dump({
      "Product": {
        "price": product.price,
        "stock": product.stock,
      }
    })
    response = https.request(request)
    
    if response.code == 200 || response.code == "200"
      puts "Produto ID_TRAY: #{product.id_tray} atualizado na Tray"
    else
      puts "[ERROR] -> Erro ao atualizar Produto ID_TRAY: #{product.id_tray} na Tray. Response: #{response.code} - #{response.body}"
    end
  end
  

  def self.request_body!(product)
    JSON.dump({
      "Product":  {
        "reference": product.sku,
        "name": product.name,
        "ncm": product.ncm,
        "description": product.description,
        "description_small": product.description,
        "price": product.price,
        "cost_price": product.cost,
        "brand": product.brand,
        "weight": product.weight,
        "length": product.length,
        "width": product.width,
        "height": product.height,
        "stock": product.stock,
        "category_id": product.category.nil? ? "35" : product.category,
        "available": product.active == "S" ? 1 : 0
      }
    })
  end

  def self.view_snk!(view_name, jsessionid)
    url = ENV["VIEW_URL_SNK"]
    body = "
      <serviceRequest serviceName='CRUDServiceProvider.loadView'> <requestBody>
      <query viewName= '#{view_name}'>
      </query>
      </requestBody> </serviceRequest>
    "

    begin
      response = RestClient::Request.execute(
        method:  :post,
        url: url,
        payload: body,
        headers: { content_type: 'text/xml;charset=ISO-8859-1', cookie: "JSESSIONID=#{jsessionid}"}
      )

      hash = Hash.from_xml(response.body)
      products = hash["serviceResponse"]["responseBody"]["records"]["record"]
    rescue Exception => e
      puts "Erro ao consultar view de produtos: #{e}"
      Honeybadger.notify("Erro ao consultar view de produtos: #{e.message}")
    end
    
    products
  end
  
  
end
