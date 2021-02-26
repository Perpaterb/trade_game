class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.integer :sold_user_id
      t.integer :buying_user_id
      t.integer :quantity
      t.integer :price_per_share

      t.timestamps
    end
  end
end
