namespace :snk do
  desc "Authenticate on SNK and GET Products on VIEW"
  task create_products: :environment do
    puts "Start snk:products"

    url_login = ENV["LOGIN_URL_SNK"]
    body_login = {
      "serviceName": "MobileLoginSP.login",
      "requestBody": {
        "NOMUSU": {
          "$": "LJ.INTEGRA"
        },
        "INTERNO":{
          "$": "studio@5512"
        },
        "KEEPCONNECTED": {
            "$": "S"
        }
      }
    }

    response = RestClient::Request.execute(
      method:  :get,   
      url: url_login,  
      payload: body_login.to_json,  
      headers: { content_type: 'application/json', accept: 'application/json'}  
    ) 
    if response.code == 200
      hash = JSON.parse(response.body)
      begin
        jsessionid = hash["responseBody"]["jsessionid"]["$"]
        url_complete_view = ENV["VIEW_URL_SNK"]
        body_complete_view = '
          <serviceRequest serviceName="CRUDServiceProvider.loadView"> <requestBody>
          <query viewName= "VGFSLL">
          </query>
          </requestBody> </serviceRequest>
        '
        begin
          response = RestClient::Request.execute(
            method:  :post,
            url: url_complete_view,
            payload: body_complete_view,
            headers: { content_type: 'text/xml;charset=ISO-8859-1', cookie: "JSESSIONID=#{jsessionid}"}
          )

          hash = Hash.from_xml(response.body)
          products = hash["serviceResponse"]["responseBody"]["records"]["record"]
          Product.save_product!(products)
        rescue Exception => e
          puts "Erro ao consultar view de produtos: #{e}"
        end
      rescue Exception => e
        puts "Erro ao obter jsessionid"
      end
    end

    puts "End snk:products"
  end
end