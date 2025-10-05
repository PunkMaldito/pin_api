require 'rails_helper'

RSpec.describe 'API::V1::Authentication', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'POST /api/v1/auth/login' do
    context 'with valid credentials' do
      it 'returns authentication token' do
        user = create(:user, email: 'test@example.com', password: 'password123')
        post '/api/v1/auth/login', params: { email: 'test@example.com', password: 'password123' }, headers: headers
        expect(response).to have_http_status(:ok)
      end

      it 'returns valid login response schema' do
        user = create(:user, email: 'test@example.com', password: 'password123')
        post '/api/v1/auth/login', params: { email: 'test@example.com', password: 'password123' }, headers: headers
        expect(response).to match_json_schema('auth_login_success')
      end

      it 'returns user data with permissions' do
        user = create(:user, email: 'test@example.com', password: 'password123')
        post '/api/v1/auth/login', params: { email: 'test@example.com', password: 'password123' }, headers: headers
        expect(json['user']['data']['attributes']['permissions']).to be_present
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized status' do
        post '/api/v1/auth/login', params: { email: 'wrong@example.com', password: 'wrong' }, headers: headers
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns valid error schema' do
        post '/api/v1/auth/login', params: { email: 'wrong@example.com', password: 'wrong' }, headers: headers
        expect(response).to match_json_schema('auth_error')
      end

      it 'returns invalid credentials error' do
        post '/api/v1/auth/login', params: { email: 'wrong@example.com', password: 'wrong' }, headers: headers
        expect(json['error']).to eq('Invalid credentials')
      end
    end
  end

  describe 'POST /api/v1/auth/signup' do
    context 'with valid parameters' do
      it 'creates new user' do
        user_attributes = attributes_for(:user)
        expect {
          post '/api/v1/auth/signup', params: { user: user_attributes }, headers: headers
        }.to change(User, :count).by(1)
      end

      it 'returns valid login response schema' do
        user_attributes = attributes_for(:user)
        post '/api/v1/auth/signup', params: { user: user_attributes }, headers: headers
        expect(response).to match_json_schema('auth_login_success')
      end

      it 'returns created status' do
        user_attributes = attributes_for(:user)
        post '/api/v1/auth/signup', params: { user: user_attributes }, headers: headers
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'does not create user' do
        expect {
          post '/api/v1/auth/signup', params: { user: { email: 'invalid' } }, headers: headers
        }.not_to change(User, :count)
      end

      it 'returns valid errors schema' do
        post '/api/v1/auth/signup', params: { user: { email: 'invalid' } }, headers: headers
        expect(response).to match_json_schema('errors')
      end

      it 'returns unprocessable entity status' do
        post '/api/v1/auth/signup', params: { user: { email: 'invalid' } }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
