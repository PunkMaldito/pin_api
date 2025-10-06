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
end
