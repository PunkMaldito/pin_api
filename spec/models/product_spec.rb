require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    subject { Product.new(name: 'nome teste', stock: 1, price: 19.5) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:stock) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_numericality_of(:stock).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
  end

  describe 'scopes' do
    let(:cheap_product) { create(:product, price: 10.0) }
    let(:expensive_product) { create(:product, price: 25.0) }

    describe '.price_greater_than' do
      it 'returns products with price greater than specified' do
        expect(described_class.price_greater_than(15)).to include(expensive_product)
      end

      it 'does not returns products with price smaller than specified' do
        expect(described_class.price_greater_than(15)).not_to include(cheap_product)
      end
    end
  end

  describe 'callbacks' do
    describe 'before_save' do
      it 'titleize name' do
        product = create(:product, name: 'produto de teste')

        expect(product.name).to eq('Produto De Teste')
      end
    end
  end
end
