class Auth < ApplicationRecord
  def self.access_token!()
    url_auth = "#{ENV['API_ADDRESS']}/auth"
    response = RestClient.post url_auth, {consumer_key: ENV['CONSUMER_KEY'], consumer_secret: ENV['CONSUMER_SECRET'], code: ENV['CODE']}
    hash = JSON.parse(response.body)
    hash["access_token"]
  end

  def self.jsessionid!()
    url = ENV["LOGIN_URL_SNK"]
    body = {
      "serviceName": "MobileLoginSP.login",
      "requestBody": {
        "NOMUSU": {
          "$": ENV['NOMUSU']
        },
        "INTERNO":{
          "$": ENV['INTERNO']
        },
        "KEEPCONNECTED": {
            "$": "S"
        }
      }
    }

    begin
      response = RestClient::Request.execute(
        method:  :get,
        url: url,
        payload: body.to_json,
        headers: { content_type: 'application/json', accept: 'application/json'}  
      )
      hash = JSON.parse(response.body)
      jsessionid = hash["responseBody"]["jsessionid"]["$"]
    rescue Exception => e
      puts "Erro ao efetuar login SNK: #{e}"
    end

    jsessionid
  end
end