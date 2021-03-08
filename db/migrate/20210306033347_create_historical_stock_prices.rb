class CreateHistoricalStockPrices < ActiveRecord::Migration[6.1]
  def change
    create_table :historical_stock_prices do |t|
      t.string :stockcode, null: false
      t.float :price, null: false

      t.timestamps
    end
  end
end
