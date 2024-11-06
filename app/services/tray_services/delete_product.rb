module TrayServices
  class DeleteProduct
    attr_reader :id_tray

    def initialize(id_tray)
      @id_tray = id_tray
    end

    def perform
      response = delete_product
      unless response.code == 200 || response.code == '200'
        raise "Response code: #{response.code} - id_tray: #{id_tray}"
      end

      puts "[SUCCESS] delete_inactive_product. id_tray: #{id_tray}"
    rescue StandardError => e
      puts "[ERROR] delete_inactive_product. Error message: #{e.message}"
    end

    private

    def access_token
      Auth.access_token!()
    end

    def url
      "#{ENV['API_ADDRESS']}/products/#{id_tray}?access_token=#{access_token}"
    end

    def delete_product
      RestClient.delete url
    end
  end
end
