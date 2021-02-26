class CreateHoldings < ActiveRecord::Migration[6.1]
  def change
    create_table :holdings do |t|
      t.integer :owner_users_ID
      t.string :stock_code
      t.integer :quantity
      t.integer :asking

      t.timestamps
    end
  end
end
