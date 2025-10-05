require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      product = build(:product, name: nil)
      expect(product).not_to be_valid
    end

    it 'validates stock is integer' do
      product = build(:product, stock: 10.5)
      expect(product).not_to be_valid
    end

    it 'validates stock is greater than or equal to zero' do
      product = build(:product, stock: -1)
      expect(product).not_to be_valid
    end

    it 'validates price is greater than or equal to zero' do
      product = build(:product, price: -1.0)
      expect(product).not_to be_valid
    end
  end

  describe '#sell' do
    it 'decreases stock by given quantity' do
      product = create(:product, stock: 100)
      product.sell(25)
      expect(product.stock).to eq(75)
    end

    it 'raises error when quantity exceeds stock' do
      product = create(:product, stock: 10)
      expect { product.sell(15) }.to raise_error(StandardError, 'Insufficient stock')
    end

    it 'raises error when quantity is not positive' do
      product = create(:product, stock: 100)
      expect { product.sell(0) }.to raise_error(ArgumentError, 'Quantity must be positive')
    end
  end

  describe '#build' do
    it 'increases stock by given quantity' do
      product = create(:product, stock: 50)
      product.build(25)
      expect(product.stock).to eq(75)
    end

    it 'raises error when quantity is not positive' do
      product = create(:product, stock: 100)
      expect { product.build(0) }.to raise_error(ArgumentError, 'Quantity must be positive')
    end
  end
end
