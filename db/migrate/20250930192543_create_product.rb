class CreateProduct < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :stock, null: false, default: 0
      t.decimal :price, precision: 8, scale: 2, null: false, default: 0.0

      t.timestamps

      t.index :name
      t.check_constraint "stock >= 0", name: "stock_non_negative"
      t.check_constraint "price >= 0", name: "price_non_negative"
    end
  end
end
