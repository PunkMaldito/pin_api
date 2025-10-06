require 'rails_helper'

RSpec.describe 'API::V1::Authentication', type: :request do
  describe 'POST /api/v1/auth/login' do
    it 'returns token with valid credentials' do
      user = create(:user, email: 'test@test.com', password: 'password123')

      post '/api/v1/auth/login', params: { email: 'test@test.com', password: 'password123' }

      expect(response).to have_http_status(:ok)
    end

    it 'returns error with invalid credentials' do
      post '/api/v1/auth/login', params: { email: 'wrong@test.com', password: 'wrong' }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
