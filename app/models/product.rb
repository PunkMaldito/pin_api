class Product < ApplicationRecord
  validates :name, presence: { message: "must be provided" }
  validates :stock,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              message: "must be a non-negative integer"
            }
  validates :price,
            numericality: {
              greater_than_or_equal_to: 0,
              message: "must be a non-negative number"
            }

  after_validation :check_database_constraints

  def sell(quantity)
    raise ArgumentError, "Quantity must be positive" unless quantity.positive?
    raise StandardError, "Insufficient stock" if quantity > stock

    with_lock do
      update!(stock: stock - quantity)
    end
  end

  def build(quantity)
    raise ArgumentError, "Quantity must be positive" unless quantity.positive?

    with_lock do
      update!(stock: stock + quantity)
    end
  end

  private

  def check_database_constraints
    return unless errors.empty?

    self.class.connection.execute("SELECT 1")
  rescue ActiveRecord::StatementInvalid => e
    if e.message.include?("stock_non_negative")
      errors.add(:stock, "cannot be negative")
    elsif e.message.include?("price_non_negative")
      errors.add(:price, "cannot be negative")
    end
  end
end
