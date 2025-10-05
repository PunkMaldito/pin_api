class UserSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :email, :role, :created_at

  attribute :permissions do |user|
    {
      can_sell: user.can_sell?,
      can_build: user.can_build?,
      can_manage_products: user.can_manage_products?
    }
  end
end
