require 'rails_helper'

RSpec.describe ProductOperations::SellService do
  describe '#call' do
    context 'with valid quantity' do
      it 'decreases product stock' do
        product = create(:product, stock: 100)
        service = described_class.new(product, 10)
        expect { service.call }.to change { product.reload.stock }.by(-10)
      end

      it 'returns success result' do
        product = create(:product, stock: 100)
        service = described_class.new(product, 10)
        result = service.call
        expect(result.success?).to be true
      end

      it 'updates the product stock correctly' do
        product = create(:product, stock: 100)
        service = described_class.new(product, 10)
        service.call
        expect(product.reload.stock).to eq(90)
      end
    end

    context 'with insufficient stock' do
      it 'does not change product stock' do
        product = create(:product, stock: 100)
        service = described_class.new(product, 150)
        expect { service.call }.not_to change { product.reload.stock }
      end

      it 'returns error result' do
        product = create(:product, stock: 100)
        service = described_class.new(product, 150)
        result = service.call
        expect(result.success?).to be false
      end

      it 'returns insufficient stock error message' do
        product = create(:product, stock: 100)
        service = described_class.new(product, 150)
        result = service.call
        expect(result.error).to eq('Insufficient stock')
      end
    end

    context 'with zero quantity' do
      it 'returns quantity must be positive error' do
        product = create(:product, stock: 100)
        service = described_class.new(product, 0)
        result = service.call
        expect(result.error).to eq('Quantity must be positive')
      end
    end

    context 'with negative quantity' do
      it 'returns quantity must be positive error' do
        product = create(:product, stock: 100)
        service = described_class.new(product, -5)
        result = service.call
        expect(result.error).to eq('Quantity must be positive')
      end
    end
  end
end
