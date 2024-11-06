module TrayServices
  class ProductRequestBody
    attr_reader :product

    def initialize(product)
      @product = product
    end

    def call
      JSON.dump(product_json)
    end

    private

    def product_json
      {
        "Product": {
          "reference": product.sku,
          "ean": '',
          "name": product.name,
          "ncm": product.ncm,
          "price": product.price,
          "cost_price": product.cost,
          "brand": product.brand,
          "stock": product.stock,
          "category_id": product.category.nil? ? '35' : product.category,
          "description": product.description,
          "weight": product.weight,
          "height": product.height,
          "width": product.width,
          "length": product.length,
          "available": product.active == 'S' ? 1 : 0
        }
      }
    end
  end
end
