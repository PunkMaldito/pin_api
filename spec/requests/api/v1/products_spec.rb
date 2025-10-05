require 'rails_helper'

RSpec.describe 'API::V1::Products', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/products' do
    context 'when authenticated' do
      it 'returns successful response' do
        user = create(:user)
        create_list(:product, 3)
        auth_headers = auth_headers(user)
        get '/api/v1/products', headers: headers.merge(auth_headers)
        expect(response).to have_http_status(:ok)
      end

      it 'returns valid products index schema' do
        user = create(:user)
        create_list(:product, 3)
        auth_headers = auth_headers(user)
        get '/api/v1/products', headers: headers.merge(auth_headers)
        expect(response).to match_json_schema('products_index')
      end

      it 'returns paginated products' do
        user = create(:user)
        create_list(:product, 15)
        auth_headers = auth_headers(user)
        get '/api/v1/products', params: { per_page: 5 }, headers: headers.merge(auth_headers)
        expect(json['data'].size).to eq(5)
      end

      it 'includes pagination metadata' do
        user = create(:user)
        create_list(:product, 3)
        auth_headers = auth_headers(user)
        get '/api/v1/products', headers: headers.merge(auth_headers)
        expect(json['meta']).to include('current_page', 'total_pages', 'total_count')
      end
    end

    context 'when not authenticated' do
      it 'returns unauthorized status' do
        get '/api/v1/products', headers: headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/products/:id' do
    context 'when product exists' do
      it 'returns successful response' do
        user = create(:user)
        product = create(:product)
        auth_headers = auth_headers(user)
        get "/api/v1/products/#{product.id}", headers: headers.merge(auth_headers)
        expect(response).to have_http_status(:ok)
      end

      it 'returns valid product show schema' do
        user = create(:user)
        product = create(:product)
        auth_headers = auth_headers(user)
        get "/api/v1/products/#{product.id}", headers: headers.merge(auth_headers)
        expect(response).to match_json_schema('products_show')
      end

      it 'returns the requested product' do
        user = create(:user)
        product = create(:product)
        auth_headers = auth_headers(user)
        get "/api/v1/products/#{product.id}", headers: headers.merge(auth_headers)
        expect(json['data']['id']).to eq(product.id.to_s)
      end
    end

    context 'when product does not exist' do
      it 'returns not found status' do
        user = create(:user)
        auth_headers = auth_headers(user)
        get '/api/v1/products/999', headers: headers.merge(auth_headers)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /api/v1/products' do
    context 'when user is admin' do
      it 'creates new product' do
        admin = create(:user, :admin)
        product_attributes = attributes_for(:product)
        auth_headers = auth_headers(admin)
        expect {
          post '/api/v1/products', params: { product: product_attributes }, headers: headers.merge(auth_headers)
        }.to change(Product, :count).by(1)
      end

      it 'returns created status' do
        admin = create(:user, :admin)
        product_attributes = attributes_for(:product)
        auth_headers = auth_headers(admin)
        post '/api/v1/products', params: { product: product_attributes }, headers: headers.merge(auth_headers)
        expect(response).to have_http_status(:created)
      end
    end

    context 'when user is not admin' do
      it 'returns forbidden status' do
        seller = create(:user, :seller)
        product_attributes = attributes_for(:product)
        auth_headers = auth_headers(seller)
        post '/api/v1/products', params: { product: product_attributes }, headers: headers.merge(auth_headers)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
