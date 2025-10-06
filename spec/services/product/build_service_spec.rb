require 'rails_helper'

RSpec.describe ProductOperations::BuildService do
  describe '#call' do
    it 'increases stock when quantity is valid' do
      product = create(:product, stock: 50)
      result = described_class.call(product, 25)

      expect(product.reload.stock).to eq(75)
    end

    it 'returns success when quantity is valid' do
      product = create(:product, stock: 50)
      result = described_class.call(product, 25)

      expect(result.success?).to be true
    end

    it 'returns error when quantity is zero' do
      product = create(:product, stock: 50)
      result = described_class.call(product, 0)

      expect(result.success?).to be false
    end

    it 'returns quantity must be positive error message' do
      product = create(:product, stock: 50)
      result = described_class.call(product, 0)

      expect(result.error).to eq("Quantity must be positive")
    end
  end
end
