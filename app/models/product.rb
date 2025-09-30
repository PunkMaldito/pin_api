class Product < ApplicationRecord
  validates :name, :stock, :price, presence: true
  validates :name, uniqueness: { case_sensitive: true }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :price, numericality: { greater_than: 0 }

  before_save :titleize_name

  scope :price_greater_than, ->(price) { where("price > ?", price) }

  private

  def titleize_name
    self.name = name.titleize
  end
end
