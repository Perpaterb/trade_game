class CreateStartCartItems < ActiveRecord::Migration[6.1]
  def change
    create_table :start_cart_items do |t|
      t.integer :owner_users_id, null: false
      t.string :stock_code, null: false
      t.integer :quantity, null: false, default: 0

      t.timestamps
    end
  end
end
