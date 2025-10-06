require 'rails_helper'

RSpec.describe 'API V1 Products Build', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'POST /api/v1/products/:id/build' do
    context 'when user is builder' do
      it 'returns successful status' do
        builder = create(:user, :builder)
        product = create(:product, stock: 50)
        auth_headers = auth_headers(builder)

        post "/api/v1/products/#{product.id}/build",
             params: { quantity: 25 },
             headers: headers.merge(auth_headers)

        expect(response).to have_http_status(:ok)
      end

      it 'increases product stock' do
        builder = create(:user, :builder)
        product = create(:product, stock: 50)
        auth_headers = auth_headers(builder)

        post "/api/v1/products/#{product.id}/build",
             params: { quantity: 25 },
             headers: headers.merge(auth_headers)

        expect(product.reload.stock).to eq(75)
      end

      it 'returns product data' do
        builder = create(:user, :builder)
        product = create(:product, stock: 50)
        auth_headers = auth_headers(builder)

        post "/api/v1/products/#{product.id}/build",
             params: { quantity: 25 },
             headers: headers.merge(auth_headers)

        expect(json['data']['id']).to eq(product.id.to_s)
      end
    end

    context 'when user is seller' do
      it 'returns forbidden status' do
        seller = create(:user, :seller)
        product = create(:product)
        auth_headers = auth_headers(seller)

        post "/api/v1/products/#{product.id}/build",
             params: { quantity: 25 },
             headers: headers.merge(auth_headers)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with zero quantity' do
      it 'returns unprocessable entity status' do
        builder = create(:user, :builder)
        product = create(:product, stock: 50)
        auth_headers = auth_headers(builder)

        post "/api/v1/products/#{product.id}/build",
             params: { quantity: 0 },
             headers: headers.merge(auth_headers)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        builder = create(:user, :builder)
        product = create(:product, stock: 50)
        auth_headers = auth_headers(builder)

        post "/api/v1/products/#{product.id}/build",
             params: { quantity: 0 },
             headers: headers.merge(auth_headers)

        expect(json['error']).to eq('Quantity must be positive')
      end
    end
  end
end
