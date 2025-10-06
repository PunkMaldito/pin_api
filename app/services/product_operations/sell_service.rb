module ProductOperations
  class SellService
    Result = Struct.new(:success?, :product, :error)

    def self.call(product, quantity)
      new(product, quantity).call
    end

    def initialize(product, quantity)
      @product = product
      @quantity = quantity.to_i
    end

    def call
      return Result.new(false, nil, "Quantity must be positive") unless @quantity.positive?
      return Result.new(false, nil, "Insufficient stock") if @quantity > @product.stock

      @product.update!(stock: @product.stock - @quantity)
      Result.new(true, @product, nil)
    rescue => e
      Result.new(false, nil, e.message)
    end
  end
end
