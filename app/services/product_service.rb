class ProductService
  def self.save_product!(products)
    products.each do |product|
      data = Product.find_by_sku(product["sku"])

      data.nil? ? ProductActions::Create.new(product).perform : ProductActions::UpdateOrDelete.new(data, product).perform

      sleep 1
    end
  end
end