class HealthController < ActionController::Base
  def show
    render json: {
      status: "OK",
      timestamp: Time.current.iso8601,
      uptime: `uptime`.chomp,
      environment: Rails.env
    }
  end
end
