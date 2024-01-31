class Product < ApplicationRecord

  def self.save_product!(products)
    
    products.each do |product|      
      data = Product.find_by_sku(product["sku"])
      if data.nil?
        product = self.new(
          sku: product["sku"], 
          active: product["ativo"], 
          price: product["preco_cheio"].to_f,
          cost: product["preco_custo"].to_f,
          ncm: product["ncm"],
          name: product["nome"],
          description: product["descricao_completa"],
          stock: product["estoque_quantidade"].blank? ? nil : product["estoque_quantidade"].to_i,
          brand: product["marca"],
          weight: [0, '0', '', nil].include?(product["peso_em_kg"]) ? 1 : product["peso_em_kg"].to_i,
          height: product["altura_em_cm"].blank? ? nil : product["altura_em_cm"].to_i,
          width: product["largura_em_cm"].blank? ? nil : product["largura_em_cm"].to_i,
          length: product["comprimento_em_cm"].blank? ? nil : product["comprimento_em_cm"].to_i,
          volume: product["codvol"]
        )

        result = Product.get_tray!(product)
        if result[:status] == "OK" && product.active != "S"
          Product.delete_inactive_product(product.id_tray)
        elsif result[:status] != "OK" && product.active == "S"
          product.save!
          Product.create_tray!(product)
        end
      else
        data.update(
          active: product["ativo"],
          price: product["preco_cheio"].to_f,
          cost: product["preco_custo"].to_f,
          ncm: product["ncm"],
          name: product["nome"],
          description: product["descricao_completa"],
          stock: product["estoque_quantidade"].blank? ? nil : product["estoque_quantidade"].to_i,
          brand: product["marca"],
          weight: [0, '0', '', nil].include?(product["peso_em_kg"]) ? 1 : product["peso_em_kg"].to_i,
          height: product["altura_em_cm"].nil? ? nil : product["altura_em_cm"].to_i,
          width: product["largura_em_cm"].nil? ? nil : product["largura_em_cm"].to_i,
          length: product["comprimento_em_cm"].nil? ? nil : product["comprimento_em_cm"].to_i,
          volume: product["codvol"]
        )

        if data.active == "S"
          result = Product.get_tray!(data)

          if result[:status] == "OK"
            Product.update_tray!(data)
          else
            Product.create_tray!(data)
          end
        else
          Product.delete_inactive_product(data.id_tray)
          data.destroy
        end
      end

      sleep 1
    end
  end

  def self.create_tray!(product)
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

      puts "[SUCCESS] Product SKU: #{product.sku} Created on Tray."
    rescue Exception => e
      puts "Erro ao enviar produto (SKU: #{product.sku}) para a Tray: #{e.message}"
      Honeybadger.notify("Erro ao enviar produto (SKU: #{product.sku}) para a Tray: #{e.message}")
    end
  end

  # Get info product on tray
  def self.get_tray!(product)
    begin
      url = "#{ENV['API_ADDRESS']}/products"
      response = RestClient.get url, {params: {'reference' => product.sku.to_s}}
    rescue Exception => e
      puts "Erro ao consultar produto SKU: #{product.sku} - ERROR #{e.message}"
    end

    hash = JSON.parse(response.body)

    if hash["Products"].empty?
      { status: "not found" }
    else
      hash_product = hash.dig('Products', 0, 'Product')
      product.update(id_tray: hash_product['id'], category: hash_product['category_id'])

      puts "Atualizado produto - id_tray: #{product.id_tray} | category: #{product.category}"

      { status: "OK" }
    end
  end
  

  def self.update_tray!(product)
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
        raise "Error update_tray: Response code was #{response.code} and body #{response.body}"
      end
    rescue Exception => e
      puts "[ERROR] update_tray! ID_TRAY: #{product.id_tray}. Error message: #{e.message}"
    end
  end
  

  def self.stock_price_tray!(id_tray, price, stock)
    access_token = Auth.access_token!()
    url = URI("#{ENV['API_ADDRESS']}/products/#{id_tray}?access_token=#{access_token}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Put.new(url)
    request["Content-Type"] = "application/json"
    request.body = JSON.dump({
      "Product": {
        "price": price,
        "stock": stock
      }
    })

    response = https.request(request)
    if response.code == 200 || response.code == "200"
      puts "[SUCCESS] Update stock_price_tray. ID_TRAY: #{id_tray}"
    else
      raise "Error on Update stock_price_tray. ID_TRAY: #{id_tray}. Response: #{response.code} - #{response.body}"
    end
  end
  

  def self.request_body!(product)
    JSON.dump({
      "Product":  {
        "reference": product.sku,
        "ean": "",
        "name": product.name,
        "ncm": product.ncm,
        "price": product.price,
        "cost_price": product.cost,
        "brand": product.brand,
        "stock": product.stock,
        "category_id": product.category.nil? ? "35" : product.category,
        "description": product.description,
        "weight": product.weight,
        "height": product.height,
        "width": product.width,
        "length": product.length,
        "available": product.active == "S" ? 1 : 0
      }
    })
  end

  def self.view_snk!(view_name)
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
        headers: { content_type: 'text/xml;charset=ISO-8859-1', cookie: "JSESSIONID=#{Auth.jsessionid!()}"}
      )

      hash = Hash.from_xml(response.body)
      hash.dig('serviceResponse', 'responseBody', 'records', 'record')
    rescue Exception => e
      puts "[ERROR] view_snk. Error message: #{e.message}"
    end
  end
  
  def self.delete_inactive_product(id_tray)
    begin
      access_token = Auth.access_token!()
      url = "#{ENV['API_ADDRESS']}/products/#{id_tray}?access_token=#{access_token}"
      response = RestClient.delete url
      if response.code == 200
        puts "[SUCCESS] delete_inactive_product. id_tray: #{id_tray}"
      else
        raise "Response code: #{response.code} - id_tray: #{id_tray}"
      end
    rescue Exception => error
      puts "[ERROR] delete_inactive_product. Error message: #{error.message}"
    end
  end
end
