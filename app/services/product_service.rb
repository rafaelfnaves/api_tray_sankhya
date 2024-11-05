class ProductService
  def self.save_product!(products)
    products.each do |product|
      data = Product.find_by_sku(product["sku"])

      data.nil? ? ProductActions::Create.new(product).call : ProductActions::UpdateOrDelete.new(data, product).call

      sleep 1
    end
  end
end