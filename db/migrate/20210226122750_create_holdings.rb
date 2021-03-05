class CreateHoldings < ActiveRecord::Migration[6.1]
  def change
    create_table :holdings do |t|
      t.integer :owner_users_ID, null: false
      t.string :stock_code, null: false
      t.float :quantity, null: false
      t.integer :asking, null: false

      t.timestamps
    end
  end
end
