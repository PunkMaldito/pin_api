module RequestHelpers
  def json
    JSON.parse(response.body)
  end

  def auth_headers(user = nil)
    token = JsonWebToken.encode(user_id: user.id)
    { 'Authorization' => "Bearer #{token}" }
  end
end
