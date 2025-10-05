module ExceptionHandler
  class InvalidToken < StandardError; end
  class MissingToken < StandardError; end
  class Unauthorized < StandardError; end

  extend ActiveSupport::Concern

  included do
    rescue_from ExceptionHandler::InvalidToken, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :unauthorized_request
    rescue_from ExceptionHandler::Unauthorized, with: :unauthorized_request
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from Pundit::NotAuthorizedError, with: :forbidden
  end

  private

  def unauthorized_request(error)
    render json: { error: error.message }, status: :unauthorized
  end

  def not_found(error)
    render json: { error: error.message }, status: :not_found
  end

  def forbidden(error)
    render json: { error: "Access denied" }, status: :forbidden
  end
end
