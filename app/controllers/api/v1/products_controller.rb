class Api::V1::ProductsController < Api::V1::ApiController
  def index
    @products = Product.all.select(
      :sku, :id_tray, :active, :name,
      :price, :stock, :ncm, :description,
      :brand, :weight, :height, :width, 
      :length, :category, :updated_at
    )

    if @products.present?
      render json: @products, status: :ok
    else
      render json: { error: "Erro ao retornar listagem de produtos" }, status: :unprocessable_entity
    end
  end

  def show
    @product = Product.find_by(sku: params[:id])

    if @product
      render json: @product, status: :ok
    else
      render json: {message: 'Produto não encontrado.'}, status: :not_found
    end
  end
end
