module ProductActions
  class Create
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def perform
      result = Product.get_tray!(product)
      if result[:status] == 'OK' && product.active != 'S'
        delete_inactive_product
      elsif result[:status] != 'OK' && product.active == 'S'
        save_and_create_at_tray
      end
    end

    private

    def product
      @product ||= Product.new(
        sku: params['sku'],
        active: params['ativo'],
        price: params['preco_cheio'].to_f,
        cost: params['preco_custo'].to_f,
        ncm: params['ncm'],
        name: params['nome'],
        description: params['descricao_completa'],
        stock: params['estoque_quantidade'].blank? ? nil : params['estoque_quantidade'].to_i,
        brand: params['marca'],
        weight: [0, '0', '', nil].include?(params['peso_em_kg']) ? 1 : params['peso_em_kg'].to_i,
        height: params['altura_em_cm'].blank? ? nil : params['altura_em_cm'].to_i,
        width: params['largura_em_cm'].blank? ? nil : params['largura_em_cm'].to_i,
        length: params['comprimento_em_cm'].blank? ? nil : params['comprimento_em_cm'].to_i,
        volume: params['codvol']
      )
    end

    def delete_inactive_product
      Product.delete_inactive_product(product.id_tray)
    end

    def save_and_create_at_tray
      product.save!
      Product.create_tray!(product)
    end
  end
end