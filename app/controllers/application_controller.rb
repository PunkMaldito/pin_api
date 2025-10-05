class ApplicationController < ActionController::API
  include ExceptionHandler
  include Pundit::Authorization

  before_action :authenticate_user!

  attr_reader :current_user

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from ActiveRecord::RecordNotUnique, with: :render_conflict
  rescue_from ActionController::ParameterMissing, with: :render_bad_request

  private

  def authenticate_user!
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last

    if token
      decoded = JsonWebToken.decode(token)
      @current_user = User.find(decoded[:user_id])
    else
      raise ExceptionHandler::MissingToken, "Missing token"
    end
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError
    raise ExceptionHandler::InvalidToken, "Invalid token"
  end

  def render_unprocessable_entity(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def render_conflict(exception)
    render json: { error: "Resource already exists" }, status: :conflict
  end

  def render_bad_request(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end
