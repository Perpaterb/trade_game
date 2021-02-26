class AddStartingstock1ToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :startingstock1, :string
  end
end
