class Customer < ApplicationRecord
  include JsessionidSnk

  has_many :orders

  def self.create_customer!(customer_id, token)
    puts "Entrou no create_customer"
    puts "---------"

    url = "#{ENV['API_ADDRESS']}/customers/#{customer_id}?access_token=#{token}"
    response = RestClient.get url
    hash = JSON.parse(response.body)
    customer = hash["Customer"]
    unless customer.nil?
      client = self.create!(
        cnpj: customer["cnpj"],
        id_tray: customer_id,
        name: customer["name"],
        rg: customer["rg"],
        cpf: customer["cpf"],
        phone: customer["phone"],
        cellphone: customer["cellphone"],
        email: customer["email"],
        company_name: customer["company_name"],
        state_inscription: customer["state_inscription"],
        blocked_tray: customer["blocked"],
        profile_customer_id: customer["profile_customer_id"],
        address: customer["address"],
        zip_code: customer["zip_code"],
        number_address: customer["number"],
        complement: customer["complement"],
        neighborhood: customer["neighborhood"],
        city: customer["city"],
        state: customer["state"]
      )
      Customer.customer_snk!(client)
    end

  end

  def self.customer_snk!(customer)
    puts "Entrou customer_snk"
    puts "-------"

    body = {
      "serviceName": "CRUDServiceProvider.loadRecords",
      "requestBody": {
        "dataSet": {
          "rootEntity": "Parceiro",
          "includePresentationFields": "N",
          "offsetPage": "0",
          "criteria": {
            "expression": {
              "$": "this.CGC_CPF = '#{ customer.cpf.empty? || customer.cpf.nil? ? customer.cnpj.to_s.gsub(/[^0-9A-Za-z]/, '')[0..13] : customer.cpf.to_s.gsub(/[^0-9A-Za-z]/, '')[0..10] }' AND CLIENTE = 'S' AND ATIVO = 'S'"
            }
          },
          "entity": {
            "fieldset": {
              "list": "CODPARC"
            }
          }
        }
      }
    }

    puts "Body get_customer snk: #{body}"

    response = RestClient::Request.execute(
      method:  :get,
      url: ENV['URL_API_SNK'],
      payload: body.to_json,
      headers: { content_type: 'application/json', cookie: "JSESSIONID=#{Auth.jsessionid!()}"}
    )

    puts "Consulta de cliente: Status #{response.code} - Body: #{response.body}"

    if response.code == 200
      hash = JSON.parse(response.body)
      if hash["responseBody"]["entities"]["total"] == "0"

        puts "Entrou para cadastrar cliente no SNK"

        body = {  
          "serviceName":"CRUDServiceProvider.saveRecord",
          "requestBody":{
             "dataSet":{
                "rootEntity":"Parceiro",
                "includePresentationFields":"S",
                "dataRow":{
                   "localFields":{
                      "TIPPESSOA":{
                         "$":"F"
                      },               
                      "NOMEPARC":{
                         "$": customer.name
                      },               
                      "CODCID":{
                         "$": City.find_by_name((customer.city).upcase.strip).codcid.to_s
                      },               
                      "ATIVO":{
                         "$":"S"
                      },
                       "CLIENTE":{
                           "$":"S"
                       },
                       "CLASSIFICMS":{
                           "$":"C"
                       },
                       "CGC_CPF":{
                           "$": customer.cpf
                       }
                   }
                }, "entity":{
                   "fieldset":{
                      "list": "CODPARC"
                   }
                }
             }
          }
        }

        response = RestClient::Request.execute(
          method:  :post,
          url: ENV['URL_API_SNK_POST'],
          payload: body.to_json,
          headers: { content_type: 'application/json', cookie: "JSESSIONID=#{Auth.jsessionid!()}"}
        )

        puts "Cadastro de cliente no SNK: Status #{response.code} - Body: #{response.body}"

        if response.code == 200
          res_body = JSON.parse(response.body)
          codparc = res_body["responseBody"]["entities"]["entity"]["CODPARC"]["$"]
          unless codparc.nil?
            customer.update_column(:code_par_snk, codparc)
          end
        end
      else
        data = hash["responseBody"]["entities"]["entity"]
        customer.update_column(:code_par_snk, data["f0"]["$"])
      end

    end
    
  end
end
