module ProductOperations
  class SellService < BaseService
    def initialize(product, quantity)
      @product = product
      @quantity = quantity
    end

    def call
      validate_quantity
      return Result.new(false, nil, "Quantity must be positive") unless @quantity.positive?

      @product.sell(@quantity)
      Result.new(true, @product, nil)
    rescue StandardError => e
      Result.new(false, nil, e.message)
    end

    private

    def validate_quantity
      @quantity = @quantity.to_i
    end
  end
end
