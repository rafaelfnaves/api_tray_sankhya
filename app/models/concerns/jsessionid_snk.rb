module JsessionidSnk
  extend ActiveSupport::Concern
  
  def jsessionid_snk
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