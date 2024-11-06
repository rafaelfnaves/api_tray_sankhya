module TrayServices
  class UpdateStockPrice
    attr_reader :id_tray, :price, :stock

    def initialize(id_tray, price, stock)
      @id_tray = id_tray
      @price = price
      @stock = stock
    end

    def perform
      response = update_stock_price
      unless response.code == 200 || response.code == '200'
        raise "Error on Update stock_price_tray. ID_TRAY: #{id_tray}. Response: #{response.code} - #{response.body}"
      end

      puts "[SUCCESS] Update stock_price_tray. ID_TRAY: #{id_tray}"
    end

    private

    def access_token
      Auth.access_token!()
    end

    def url
      URI("#{ENV['API_ADDRESS']}/products/#{id_tray}?access_token=#{access_token}")
    end

    def http
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http
    end

    def update_stock_price
      request = Net::HTTP::Put.new(url)
      request['Content-Type'] = 'application/json'
      request.body = JSON.dump({ "Product": { "price": price, "stock": stock } })

      https.request(request)
    end
  end
end
