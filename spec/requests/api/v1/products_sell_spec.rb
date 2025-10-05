require 'rails_helper'

RSpec.describe 'API::V1::ProductsSell', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'POST /api/v1/products/:id/sell' do
    context 'when user is seller' do
      it 'returns successful response' do
        seller = create(:user, :seller)
        product = create(:product, stock: 100)
        auth_headers = auth_headers(seller)
        post "/api/v1/products/#{product.id}/sell", params: { quantity: 10 }, headers: headers.merge(auth_headers)
        expect(response).to have_http_status(:ok)
      end

      it 'returns valid success schema' do
        seller = create(:user, :seller)
        product = create(:product, stock: 100)
        auth_headers = auth_headers(seller)
        post "/api/v1/products/#{product.id}/sell", params: { quantity: 10 }, headers: headers.merge(auth_headers)
        expect(response).to match_json_schema('products_success')
      end

      it 'decreases product stock' do
        seller = create(:user, :seller)
        product = create(:product, stock: 100)
        auth_headers = auth_headers(seller)
        post "/api/v1/products/#{product.id}/sell", params: { quantity: 10 }, headers: headers.merge(auth_headers)
        expect(product.reload.stock).to eq(90)
      end

      it 'returns success message' do
        seller = create(:user, :seller)
        product = create(:product, stock: 100)
        auth_headers = auth_headers(seller)
        post "/api/v1/products/#{product.id}/sell", params: { quantity: 10 }, headers: headers.merge(auth_headers)
        expect(json['message']).to eq('Sold 10 units successfully')
      end
    end

    context 'when user is builder' do
      it 'returns forbidden status' do
        builder = create(:user, :builder)
        product = create(:product, stock: 100)
        auth_headers = auth_headers(builder)
        post "/api/v1/products/#{product.id}/sell", params: { quantity: 10 }, headers: headers.merge(auth_headers)
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with insufficient stock' do
      it 'returns unprocessable entity status' do
        seller = create(:user, :seller)
        product = create(:product, stock: 100)
        auth_headers = auth_headers(seller)
        post "/api/v1/products/#{product.id}/sell", params: { quantity: 150 }, headers: headers.merge(auth_headers)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns valid error schema' do
        seller = create(:user, :seller)
        product = create(:product, stock: 100)
        auth_headers = auth_headers(seller)
        post "/api/v1/products/#{product.id}/sell", params: { quantity: 150 }, headers: headers.merge(auth_headers)
        expect(response).to match_json_schema('error')
      end

      it 'returns error message' do
        seller = create(:user, :seller)
        product = create(:product, stock: 100)
        auth_headers = auth_headers(seller)
        post "/api/v1/products/#{product.id}/sell", params: { quantity: 150 }, headers: headers.merge(auth_headers)
        expect(json['error']).to eq('Insufficient stock')
      end
    end
  end
end
