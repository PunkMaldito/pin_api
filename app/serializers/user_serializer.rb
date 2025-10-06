class UserSerializer
  include JSONAPI::Serializer

  set_type :user
  attributes :id, :name, :email, :role, :created_at, :updated_at
end
