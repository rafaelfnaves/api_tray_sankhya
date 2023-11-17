class Customer < ApplicationRecord
  include JsessionidSnk

  has_many :orders

  def self.create_customer!(customer_id, token)
    puts "Entrou no create_customer"
    puts "---------"

    url = "#{ENV['API_ADDRESS']}/customers/#{customer_id}?access_token=#{token}"
    begin
      response = RestClient.get url
      hash = JSON.parse(response.body)

      self.customer_snk(hash["Customer"])
    rescue Exception => error
      puts "Error on consult customer at Tray: \n 
            URL: #{url} \n 
            Error message: #{error.message}"
    end
  end

  private

  def self.customer_snk(customer)

    puts "Init Customer Model"
    puts "-------"
    puts ""

    body = {
      "serviceName": "CRUDServiceProvider.loadRecords",
      "requestBody": {
        "dataSet": {
          "rootEntity": "Parceiro",
          "includePresentationFields": "N",
          "offsetPage": "0",
          "criteria": {
            "expression": {
              "$": "this.CGC_CPF = '#{ customer["cpf"].blank? ? customer["cnpj"].to_s.gsub(/[^0-9A-Za-z]/, '')[0..13] : customer["cpf"].to_s.gsub(/[^0-9A-Za-z]/, '')[0..10] }' AND CLIENTE = 'S' AND ATIVO = 'S'"
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

    puts "Body customer snk: \n #{body}"
    puts ""

    begin
      response = RestClient::Request.execute(
        method:  :get,
        url: ENV['URL_API_SNK'],
        payload: body.to_json,
        headers: { content_type: 'application/json', cookie: "JSESSIONID=#{Auth.jsessionid!()}"}
      )

      puts "[SUCCESS] customer_snk: \n
            Status #{response.code} - Body: #{response.body}"
      puts ""
    rescue Exception => error
      puts "[ERROR] customer_snk: \n
            Status #{response.code} - Body: #{response.body} \n
            Error message: #{error.message}"
    end

    if response.code == 200
      hash = JSON.parse(response.body)
      total = hash.dig('responseBody', 'entities', 'total')
      if total == "0"
        codparc = self.sign_up_snk(customer["name"], customer["city"], customer["cpf"])
      else
        codparc = hash.dig('responseBody', 'entities', 'entity', 'f0', '$')
      end

      Customer.create!(
        cnpj: customer['cnpj'],
        id_tray: customer['id'],
        name: customer['name'],
        rg: customer['rg'],
        cpf: customer['cpf'],
        phone: customer['phone'],
        cellphone: customer['cellphone'],
        email: customer['email'],
        company_name: customer['company_name'],
        state_inscription: customer['state_inscription'],
        blocked_tray: customer['blocked'],
        profile_customer_id: customer['profile_customer_id'],
        address: customer['address'],
        zip_code: customer['zip_code'],
        number_address: customer['number'],
        complement: customer['complement'],
        neighborhood: customer['neighborhood'],
        city: customer['city'],
        state: customer['state'],
        code_par_snk: codparc
      )
    end
  end

  def self.sign_up_snk(name, city, cpf)
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
                      "$": name
                  },               
                  "CODCID":{
                      "$": City.find_by_name((city).upcase.strip).codcid.to_s
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
                        "$": cpf
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

    begin
      response = RestClient::Request.execute(
        method:  :post,
        url: ENV['URL_API_SNK_POST'],
        payload: body.to_json,
        headers: { content_type: 'application/json', cookie: "JSESSIONID=#{Auth.jsessionid!()}"}
      )
  
      res_body = JSON.parse(response.body)
      codparc = res_body.dig('responseBody', 'entities', 'entity', 'CODPARC', '$')
  
      puts "[SUCCESS] sign_up_snk. Customer: #{name} \n 
            Status #{response.code} - Body: #{response.body}"

      codparc
    rescue Exception => error
      puts "[ERROR] sign_up_snk. Customer: #{name}: \n 
            Status #{response.code} - Body: #{response.body} \n
            Error message: #{error.message}"
    end
  end
end
