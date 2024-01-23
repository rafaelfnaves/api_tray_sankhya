class Api::V1::OrdersController < Api::V1::ApiController
  def index
    @orders = Order.all

    if @orders.present?
      render json: @orders, status: :ok
    else
      render json: { error: "Nenhum pedido encontrado ou erro ao retornar listagem" }, status: :unprocessable_entity
    end
  end

  def show
    @order = Order.find_by(id_tray: params[:id])

    if @order
      render json: @order, status: :ok
    else
      render json: {message: 'Pedido não encontrado.'}, status: :not_found
    end
  end
end
