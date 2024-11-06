module SankhyaServices
  class Auth
    def call
      response = fetch_session_id
      hash = JSON.parse(response.body)
      hash.dig('responseBody', 'jsessionid', '$')
    rescue StandardError => e
      puts "Erro ao efetuar login SNK: #{e.message}"
    end

    private

    def url
      ENV['LOGIN_URL_SNK']
    end

    def body
      {
        "serviceName": 'MobileLoginSP.login',
        "requestBody": {
          "NOMUSU": { "$": ENV['NOMUSU'] },
          "INTERNO": { "$": ENV['INTERNO'] },
          "KEEPCONNECTED": { "$": 'S' }
        }
      }
    end

    def fetch_session_id
      RestClient::Request.execute(
        method: :get,
        url:,
        payload: body.to_json,
        headers: { content_type: 'application/json', accept: 'application/json' }
      )
    end
  end
end
