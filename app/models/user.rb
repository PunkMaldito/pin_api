class User < ApplicationRecord
  has_secure_password

  enum :role, {
    seller: "seller",
    builder: "builder",
    admin: "admin"
  }, default: "seller", validate: true

  validates :name, presence: { message: "must be provided" }
  validates :email,
            presence: { message: "must be provided" },
            uniqueness: { message: "is already taken" },
            format: {
              with: URI::MailTo::EMAIL_REGEXP,
              message: "must be a valid email address"
            }
  validates :password,
            length: {
              minimum: 6,
              message: "must be at least 6 characters long",
              if: -> { new_record? || !password.nil? }
            }

  def can_sell?
    seller? || admin?
  end

  def can_build?
    builder? || admin?
  end

  def can_manage_products?
    admin?
  end

  scope :admins, -> { where(role: "admin") }
  scope :sellers, -> { where(role: "seller") }
  scope :builders, -> { where(role: "builder") }
end
