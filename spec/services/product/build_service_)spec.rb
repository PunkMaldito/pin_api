require 'rails_helper'

RSpec.describe ProductOperations::BuildService do
  describe '#call' do
    context 'with valid quantity' do
      it 'increases product stock' do
        product = create(:product, stock: 50)
        service = described_class.new(product, 25)
        expect { service.call }.to change { product.reload.stock }.by(25)
      end

      it 'returns success result' do
        product = create(:product, stock: 50)
        service = described_class.new(product, 25)
        result = service.call
        expect(result.success?).to be true
      end

      it 'updates the product stock correctly' do
        product = create(:product, stock: 50)
        service = described_class.new(product, 25)
        service.call
        expect(product.reload.stock).to eq(75)
      end
    end

    context 'with zero quantity' do
      it 'returns quantity must be positive error' do
        product = create(:product, stock: 50)
        service = described_class.new(product, 0)
        result = service.call
        expect(result.error).to eq('Quantity must be positive')
      end
    end

    context 'with negative quantity' do
      it 'returns quantity must be positive error' do
        product = create(:product, stock: 50)
        service = described_class.new(product, -10)
        result = service.call
        expect(result.error).to eq('Quantity must be positive')
      end
    end
  end
end
