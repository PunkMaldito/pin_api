class User < ApplicationRecord
  has_secure_password

  enum :role, { seller: "seller", builder: "builder", admin: "admin" }, default: :seller

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end
