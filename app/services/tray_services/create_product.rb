module TrayServices
  class CreateProduct
    attr_accessor :product

    def initialize(product)
      @product = product
    end

    def perform
      response = create_product_at_tray
      handle_response(response)
    rescue StandardError => e
      puts "Erro ao enviar produto (SKU: #{product.sku}) para a Tray: #{e.message}"
    end

    private

    def access_token
      Auth.access_token!()
    end

    def url
      URI("#{ENV['API_ADDRESS']}/products?access_token=#{access_token}")
    end

    def http
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http
    end

    def request_body
      TrayServices::ProductRequestBody.new(product).call
    end

    def create_product_at_tray
      request = Net::HTTP::Post.new(url)
      request['Content-Type'] = 'application/json'
      request.body = request_body
      https.request(request)
    end

    def handle_response(response)
      hash = JSON.parse(response.body)
      product.id_tray = hash['id']
      product.save!

      puts "[SUCCESS] Product SKU: #{product.sku} Created on Tray."
    end
  end
end
