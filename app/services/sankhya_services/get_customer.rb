module SankhyaServices
  class GetCustomer
    attr_reader :customer

    def initialize(customer)
      @customer = customer
    end

    def call
      fetch_customer
    end

    private

    def document_identifier
      return customer['cnpj'].to_s.gsub(/[^0-9A-Za-z]/, '')[0..13] if customer['cpf'].blank?

      customer['cpf'].to_s.gsub(/[^0-9A-Za-z]/, '')[0..10]
    end

    def body
      {
        "serviceName": 'CRUDServiceProvider.loadRecords',
        "requestBody": {
          "dataSet": {
            "rootEntity": 'Parceiro',
            "includePresentationFields": 'N',
            "offsetPage": '0',
            "criteria": {
              "expression": {
                "$": "this.CGC_CPF = '#{document_identifier}' AND CLIENTE = 'S' AND ATIVO = 'S'"
              }
            },
            "entity": {
              "fieldset": {
                "list": 'CODPARC'
              }
            }
          }
        }
      }
    end

    def session_id
      SankhyaServices::Auth.call
    end

    def url
      ENV['URL_API_SNK']
    end

    def fetch_customer
      RestClient::Request.execute(
        method: :get,
        url:,
        payload: body.to_json,
        headers: { content_type: 'application/json', cookie: "JSESSIONID=#{session_id}" }
      )
    end
  end
end
