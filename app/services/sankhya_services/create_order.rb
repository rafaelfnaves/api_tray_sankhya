module SankhyaServices
  class CreateOrder
    attr_reader :codparc, :products, :pay_date, :obs

    def initialize(codparc, products, pay_date, obs)
      @codparc = codparc
      @products = products
      @pay_date = pay_date
      @obs = obs
    end

    def perform
      create_order
    end

    private

    def body
      {
        "serviceName": 'CACSP.incluirNota',
        "requestBody": {
          "nota": {
            "cabecalho": {
              "NUNOTA": {},
              "CODPARC": { "$": codparc.to_i },
              "DTNEG": { "$": pay_date.to_time.strftime('%d/%m/%Y') },
              "CODTIPOPER": { "$": ENV['CODTIPOPER'].to_i },
              "CODTIPVENDA": { "$": ENV['CODTIPVENDA'].to_i },
              "CODVEND": { "$": ENV['CODVEND'].to_i },
              "CODEMP": { "$": ENV['CODEMP'].to_i },
              "TIPMOV": { "$": ENV['TIPMOV'] },
              "CODNAT": { "$": ENV['CODNAT'].to_i },
              "CODCENCUS": { "$": ENV['CODCENCUS'].to_i },
              "CODPARCTRANSP": { "$": ENV['CODPARCTRANSP'].to_i },
              "AD_END_LOJAINTEGRADA": { "$": obs }
            },
            "itens": { "INFORMARPRECO": 'True', "item": products }
          }
        }
      }
    end

    def session_id
      SankhyaServices::Auth.call
    end

    def url
      "#{ENV['URL_SNK_ORDER_POST']}&mgeSession=#{session_id}&outputType=json"
    end

    def create_order
      response = RestClient::Request.execute(
        method: :post,
        url:,
        payload: body.to_json,
        headers: { content_type: 'application/json' }
      )

      JSON.parse(response.body)
    end
  end
end
