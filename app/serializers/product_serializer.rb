class ProductSerializer
  include JSONAPI::Serializer

  set_type :product
  attributes :name, :stock, :price, :created_at, :updated_at
end
