class ApplicationController < ActionController::API
  include Pundit::Authorization

  before_action :authenticate_user!

  attr_reader :current_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def authenticate_user!
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last

    if token
      decoded = JsonWebToken.decode(token)
      @current_user = User.find(decoded[:user_id])
    else
      render json: { error: "Missing token" }, status: :unauthorized
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Invalid token" }, status: :unauthorized
  end

  def user_not_authorized
    render json: { error: "Access denied" }, status: :forbidden
  end
end
