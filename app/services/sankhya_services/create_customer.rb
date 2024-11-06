module SankhyaServices
  class CreateCustomer
    attr_reader :name, :city, :cpf

    def initialize(name, city, cpf)
      @name = name
      @city = city
      @cpf = cpf
    end

    def perfom
    end

    private

    def codcid
      city = City.find_by_name(city.upcase.strip)
      city.codcid.to_s
    end

    def body
      {
        "serviceName": 'CRUDServiceProvider.saveRecord',
        "requestBody": {
          "dataSet": {
            "rootEntity": 'Parceiro',
            "includePresentationFields": 'S',
            "dataRow": {
              "localFields": {
                "TIPPESSOA": { "$": 'F' },
                "NOMEPARC": { "$": name },
                "CODCID": { "$": codcid },
                "ATIVO": { "$": 'S' },
                "CLIENTE": { "$": 'S' },
                "CLASSIFICMS": { "$": 'C' },
                "CGC_CPF": { "$": cpf }
              }
            },
            "entity": { "fieldset": { "list": 'CODPARC' } }
          }
        }
      }
    end

    def url
      ENV['URL_API_SNK_POST']
    end

    def session_id
      SankhyaServices::Auth.call
    end

    def create_customer
      RestClient::Request.execute(
        method: :post,
        url:,
        payload: body.to_json,
        headers: { content_type: 'application/json', cookie: "JSESSIONID=#{session_id}"}
      )
    end
  end
end
