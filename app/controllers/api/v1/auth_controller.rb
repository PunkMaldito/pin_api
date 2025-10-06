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
            user: UserSerializer.new(user).serializable_hash
          }
        else
          render json: { error: "Invalid credentials" }, status: :unauthorized
        end
      end
    end
  end
end
