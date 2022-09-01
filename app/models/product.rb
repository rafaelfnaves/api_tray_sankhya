class Product < ApplicationRecord
  validates_uniqueness_of :sku, on: :create, message: "SKU já existe."

  def self.save_product!(products)
    
    products.each do |product|      
      data = Product.find_by_sku(product["sku"])
      if data.nil?
        self.create!(
          sku: product["sku"], 
          active: product["ativo"], 
          price: product["preco_cheio"].to_f,
          cost: product["preco_custo"].to_f,
          ncm: product["ncm"],
          name: product["nome"],
          description: product["descricao_completa"],
          stock: product["estoque_quantidade"].nil? ? nil : product["estoque_quantidade"].to_i,
          brand: product["marca"],
          weight: product["peso_em_kg"].nil? ? nil : product["peso_em_kg"].to_i,
          height: product["altura_em_cm"].nil? ? nil : product["altura_em_cm"].to_i,
          width: product["largura_em_cm"].nil? ? nil : product["largura_em_cm"].to_i,
          length: product["comprimento_em_cm"].nil? ? nil : product["comprimento_em_cm"].to_i
        )
      else
        data.update_column(:active, product["ativo"])
        data.update_column(:price, product["preco_cheio"].to_f)
        data.update_column(:cost, product["preco_custo"].to_f)
        data.update_column(:ncm, product["ncm"])
        data.update_column(:name, product["nome"])
        data.update_column(:description, product["descricao_completa"])
        data.update_column(:stock, product["estoque_quantidade"].nil? ? nil : product["estoque_quantidade"].to_i)
        data.update_column(:brand, product["marca"],)
        data.update_column(:weight, product["peso_em_kg"].nil? ? nil : product["peso_em_kg"].to_i)
        data.update_column(:height, product["altura_em_cm"].nil? ? nil : product["altura_em_cm"].to_i)
        data.update_column(:width, product["largura_em_cm"].nil? ? nil : product["largura_em_cm"].to_i)
        data.update_column(:length, product["comprimento_em_cm"].nil? ? nil : product["comprimento_em_cm"].to_i)
      end
    end
  end

  def self.send_tray!(access_token)
    products = Product.where(active: "S")
    products.each do |product|
      if product.id_tray.present?
        begin
          url = URI("#{ENV['API_ADDRESS']}/products/#{product.id_tray}?access_token=#{access_token}")
          https = Net::HTTP.new(url.host, url.port)
          https.use_ssl = true
          request = Net::HTTP::Put.new(url)
          request["Content-Type"] = "application/json"
          request.body = Product.request_body!(product)
          response = https.request(request)
          
          if response.code == 200
            puts "Produto ID_TRAY: #{product.id_tray} atualizado na Tray"
          else
            puts "[ERROR] -> Erro ao atualizar Produto ID_TRAY: #{product.id_tray} na Tray. Response: #{response.code} - #{response.body}"
          end
        rescue Exception => e
          puts "Não possível atualizar o produto (ID: #{product.id_tray}) na Tray. Erro: #{e.message}"
        end
      else
        begin
          url = URI("#{ENV['API_ADDRESS']}/products?access_token=#{access_token}")
          https = Net::HTTP.new(url.host, url.port)
          https.use_ssl = true
          request = Net::HTTP::Post.new(url)
          request["Content-Type"] = "application/json"
          request.body = Product.request_body!(product)
          response = https.request(request)
          
          if response.code == 200 || response.code == 201
            hash = JSON.parse(response.body)
            product.update_column(:id_tray, hash["id"])
            puts "Produto ID_TRAY: #{product.id_tray} criado na Tray"
          end
        rescue Exception => e
          puts "Erro ao enviar produto (SKU: #{product.sku}) para a Tray: #{e.message}"
        end
      end
    end
  end

  def self.request_body!(product)  
    JSON.dump({
      "Product":  {
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
        "category_id": "888954448",
        "available": 1
      }
    })
  end
end
