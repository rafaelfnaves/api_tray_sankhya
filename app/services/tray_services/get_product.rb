module TrayServices
  class GetProduct
    attr_reader :product

    def initialize(product)
      @product = product
    end

    def perform
      response = fetch_product
      hash = JSON.parse(response.body)
      return { status: 'not found' } if hash['Products'].empty?

      update_product(hash)
    end

    private

    def url
      "#{ENV['API_ADDRESS']}/products"
    end

    def fetch_product
      RestClient.get url, { params: { 'reference' => product.sku.to_s } }
    end

    def update_product(hash)
      product_tray = hash.dig('Products', 0, 'Product')
      product.update(id_tray: product_tray['id'], category: product_tray['category_id'])

      puts "Atualizado produto - id_tray: #{product.id_tray} | category: #{product.category}"

      { status: "OK" }
    end
  end
end