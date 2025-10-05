module SchemaHelpers
  def expect_valid_auth_response
    expect(response).to match_json_schema('auth_login_success')
  end

  def expect_valid_products_index_response
    expect(response).to match_json_schema('products_index')
  end

  def expect_valid_product_response
    expect(response).to match_json_schema('products_show')
  end

  def expect_valid_error_response
    expect(response).to match_json_schema('error')
  end

  def expect_valid_errors_response
    expect(response).to match_json_schema('errors')
  end
end
