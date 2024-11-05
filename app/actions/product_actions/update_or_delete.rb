module ProductActions
  class UpdateOrDelete
    attr_accessor :product, :params

    def initialize(product, params)
      @product = product
      @params = params
    end

    def perform
      update_product

      product.active == 'S' ? update_or_create_at_tray : delete_product
    end

    private

    def update_product
      product.update(
        active: params['ativo'],
        price: params['preco_cheio'].to_f,
        cost: params['preco_custo'].to_f,
        ncm: params['ncm'],
        name: params['nome'],
        description: params['descricao_completa'],
        stock: params['estoque_quantidade'].blank? ? nil : params['estoque_quantidade'].to_i,
        brand: params['marca'],
        weight: [0, '0', '', nil].include?(params['peso_em_kg']) ? 1 : params['peso_em_kg'].to_i,
        height: params['altura_em_cm'].nil? ? nil : params['altura_em_cm'].to_i,
        width: params['largura_em_cm'].nil? ? nil : params['largura_em_cm'].to_i,
        length: params['comprimento_em_cm'].nil? ? nil : params['comprimento_em_cm'].to_i,
        volume: params['codvol']
      )
    end

    def update_or_create_at_tray
      result = Product.get_tray!(product)
      result[:status] == 'OK' ? Product.update_tray!(product) : Product.create_tray!(product)
    end

    def delete_product
      Product.delete_inactive_product(product.id_tray)
      product.destroy
    end
  end
end