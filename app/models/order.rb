class Order < ApplicationRecord
   belongs_to :customer

   def self.get_order!(id_tray)
      Rails.logger.info "Entrou get_order"
   
      token = Auth.access_token!()
      url = "#{ENV['API_ADDRESS']}/orders/#{id_tray}/complete?access_token=#{token}"
      Rails.logger.info "URL: #{url}"
      response = RestClient.get url
      hash = JSON.parse(response.body)

      Rails.logger.info "Response: #{response.code} - #{response.body}"

      order = hash["Order"]
      if order["has_payment"] == "1"
         customer = Customer.find_by_id_tray(order["customer_id"]) # Consultar qual é cliente na Tray e cadastrar no banco intermediário e conferir se existe no SNK, caso não exista, cadastrar e pegar o CODPARC e salvar no banco
         if customer.nil?
            customer = Customer.create_customer!(order["customer_id"], token)
         end

         puts "Cliente: #{customer.name} - CODPARC: #{customer.code_par_snk}"

         items = []
         order["ProductsSold"].each do |pr_sold|
            product = Product.find_by_id_tray(pr_sold["ProductsSold"]["product_id"])
            item = {
               "NUNOTA":{
               },
               "CODPROD":{
                   "$": product.sku.to_i
               },
               "QTDNEG":{
                   "$": pr_sold["ProductsSold"]["quantity"].to_f
               },
               "CODLOCALORIG":{
                   "$":"20100".to_i
               },
               "CODVOL":{
                   "$": product.volume
               },
               "VLRUNIT":{
                   "$": pr_sold["ProductsSold"]["price"].to_f
               },
               "PERCDESC":{
                   "$": "0".to_f
               }
            }
            items << item
         end

         puts "Produtos comprados: #{items}"
         
         obs = "
         Frete: #{order["shipment"]},\n
         Valor do frete: #{order["shipment_value"]},\n
         Data de entrega: #{order["shipment_date"]},\n 
         Método de Pagamento:#{order["payment_method"]}
         "
         nu_nota = Order.create_snk!(customer.code_par_snk, items, order["payment_date"], obs)
            
         self.create!(
            nu_nota: nu_nota,
            date: order["date"],
            total: order["total"],
            payment_date: order["payment_date"],
            id_tray: order["id"],
            customer_id: customer.id,
         )

         puts "Finaliza Pedido"    
      end
   end

   def self.create_snk!(codparc, products, pay_date, obs)
      body = {
         "serviceName":"CACSP.incluirNota",
         "requestBody":{
            "nota":{
               "cabecalho":{
                  "NUNOTA":{
                  },
                  "CODPARC":{
                     "$": codparc.to_i
                  },
                  "DTNEG":{
                     "$": pay_date.to_time.strftime("%d/%m/%Y")
                  },
                  "CODTIPOPER":{
                     "$": ENV['CODTIPOPER'].to_i
                  },
                  "CODTIPVENDA":{
                     "$": ENV['CODTIPVENDA'].to_i
                  },
                  "CODVEND":{
                     "$": ENV['CODVEND'].to_i
                  },
                  "CODEMP":{
                     "$": ENV['CODEMP'].to_i
                  },
                  "TIPMOV":{
                     "$": ENV['TIPMOV']
                  },
                  "CODNAT":{
                     "$": ENV['CODNAT'].to_i
                  },
                  "CODCENCUS":{
                     "$": ENV['CODCENCUS'].to_i
                  },
                  "CODPARCTRANSP":{
                     "$": ENV['CODPARCTRANSP'].to_i
                  },
                  "AD_END_LOJAINTEGRADA":{
                     "$": obs
                  }
               },
               "itens":{
                  "INFORMARPRECO":"True",
                  "item": products
               }
            }
         }
      }

      response = RestClient::Request.execute(
         method:  :post,
         url: "#{ENV['URL_SNK_ORDER_POST']}&mgeSession=#{Auth.jsessionid!()}&outputType=json",
         payload: body.to_json,
         headers: { content_type: 'application/json' }
      )

      puts "Cadastro de cliente no SNK: Status #{response.code} - Body: #{response.body}"

      if response.code == 200
         res_body = JSON.parse(response.body)
         codparc = res_body["responseBody"]["pk"]["NUNOTA"]["$"]
      end

      codparc
   end
end
