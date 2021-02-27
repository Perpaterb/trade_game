class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.integer :sold_user_id, null: false
      t.integer :buying_user_id, null: false
      t.string :stock_code, null: false
      t.integer :quantity, null: false
      t.integer :price_per_share, null: false

      t.timestamps
    end
  end
end
