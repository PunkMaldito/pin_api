module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_user!

      def login
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          render json: {
            token: token,
            user: UserSerializer.new(user).serializable_hash[:data]
          }, status: :ok
        else
          render json: { error: "Invalid credentials" }, status: :unauthorized
        end
      end

      def signup
        user = User.new(user_params)

        if user.save
          token = JsonWebToken.encode(user_id: user.id)
          render json: {
            token: token,
            user: UserSerializer.new(user).serializable_hash[:data]
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :role)
      end
    end
  end
end
