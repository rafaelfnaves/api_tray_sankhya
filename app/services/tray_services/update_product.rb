module TrayServices
  class UpdateProduct
    attr_reader :product

    def initialize(product)
      @product = product
    end

    def perform
      response = update_product_at_tray
      unless response.code == 200 || response.code == '200'
        raise "Error update_tray: Response code was #{response.code} and body #{response.body}"
      end

      puts "Produto ID_TRAY: #{product.id_tray} atualizado na Tray"
    rescue StandardError => e
      puts "[ERROR] update_tray! ID_TRAY: #{product.id_tray}. Error message: #{e.message}"
    end

    private

    def access_token
      Auth.access_token!()
    end

    def url
      URI("#{ENV['API_ADDRESS']}/products/#{product.id_tray}?access_token=#{access_token}")
    end

    def http
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http
    end

    def request_body
      TrayServices::ProductRequestBody.new(product).call
    end

    def update_product_at_tray
      request = Net::HTTP::Put.new(url)
      request['Content-Type'] = 'application/json'
      request.body = request_body
      https.request(request)
    end
  end
end
