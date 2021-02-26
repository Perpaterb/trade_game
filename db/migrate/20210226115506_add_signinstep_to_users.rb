class AddSigninstepToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :signinstep, :integer, default: 1, null: false
  end
end
