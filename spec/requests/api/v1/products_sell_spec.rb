require 'rails_helper'

RSpec.describe 'API V1 Products Sell', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'POST /api/v1/products/:id/sell' do
    context 'when user is seller' do
      it 'returns successful status' do
        seller = create(:user, :seller)
        product = create(:product, stock: 100)
        auth_headers = auth_headers(seller)

        post "/api/v1/products/#{product.id}/sell",
             params: { quantity: 10 },
             headers: headers.merge(auth_headers)

        expect(response).to have_http_status(:ok)
      end

      it 'decreases product stock' do
        seller = create(:user, :seller)
        product = create(:product, stock: 100)
        auth_headers = auth_headers(seller)

        post "/api/v1/products/#{product.id}/sell",
             params: { quantity: 10 },
             headers: headers.merge(auth_headers)

        expect(product.reload.stock).to eq(90)
      end

      it 'returns product data' do
        seller = create(:user, :seller)
        product = create(:product, stock: 100)
        auth_headers = auth_headers(seller)

        post "/api/v1/products/#{product.id}/sell",
             params: { quantity: 10 },
             headers: headers.merge(auth_headers)

        expect(json['data']['id']).to eq(product.id.to_s)
      end
    end

    context 'when user is builder' do
      it 'returns forbidden status' do
        builder = create(:user, :builder)
        product = create(:product, stock: 100)
        auth_headers = auth_headers(builder)

        post "/api/v1/products/#{product.id}/sell",
             params: { quantity: 10 },
             headers: headers.merge(auth_headers)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with insufficient stock' do
      it 'returns unprocessable entity status' do
        seller = create(:user, :seller)
        product = create(:product, stock: 5)
        auth_headers = auth_headers(seller)

        post "/api/v1/products/#{product.id}/sell",
             params: { quantity: 10 },
             headers: headers.merge(auth_headers)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns insufficient stock error message' do
        seller = create(:user, :seller)
        product = create(:product, stock: 5)
        auth_headers = auth_headers(seller)

        post "/api/v1/products/#{product.id}/sell",
             params: { quantity: 10 },
             headers: headers.merge(auth_headers)

        expect(json['error']).to eq('Insufficient stock')
      end
    end

    context 'with zero quantity' do
      it 'returns unprocessable entity status' do
        seller = create(:user, :seller)
        product = create(:product, stock: 100)
        auth_headers = auth_headers(seller)

        post "/api/v1/products/#{product.id}/sell",
             params: { quantity: 0 },
             headers: headers.merge(auth_headers)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns quantity must be positive error message' do
        seller = create(:user, :seller)
        product = create(:product, stock: 100)
        auth_headers = auth_headers(seller)

        post "/api/v1/products/#{product.id}/sell",
             params: { quantity: 0 },
             headers: headers.merge(auth_headers)

        expect(json['error']).to eq('Quantity must be positive')
      end
    end
  end
end
