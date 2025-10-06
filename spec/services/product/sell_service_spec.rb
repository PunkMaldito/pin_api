require 'rails_helper'

RSpec.describe ProductOperations::SellService do
  describe '#call' do
    it 'decreases stock when quantity is valid' do
      product = create(:product, stock: 100)
      result = described_class.call(product, 25)

      expect(product.reload.stock).to eq(75)
    end

    it 'returns success when quantity is valid' do
      product = create(:product, stock: 100)
      result = described_class.call(product, 25)

      expect(result.success?).to be true
    end

    it 'returns error when quantity exceeds stock' do
      product = create(:product, stock: 10)
      result = described_class.call(product, 15)

      expect(result.success?).to be false
    end

    it 'returns insufficient stock error message' do
      product = create(:product, stock: 10)
      result = described_class.call(product, 15)

      expect(result.error).to eq("Insufficient stock")
    end
  end
end
