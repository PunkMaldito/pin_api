require 'rails_helper'

RSpec.describe 'API V1 Products', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { { 'Authorization' => "Bearer #{JsonWebToken.encode(user_id: user.id)}" } }

  describe 'GET /api/v1/products' do
    it 'returns products' do
      create(:product)

      get '/api/v1/products', headers: auth_headers

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /api/v1/products/:id/sell' do
    it 'sells products when user is seller' do
      seller = create(:user, :seller)
      auth_headers = { 'Authorization' => "Bearer #{JsonWebToken.encode(user_id: seller.id)}" }
      product = create(:product, stock: 100)

      post "/api/v1/products/#{product.id}/sell", params: { quantity: 10 }, headers: auth_headers

      expect(response).to have_http_status(:ok)
    end
  end
end
