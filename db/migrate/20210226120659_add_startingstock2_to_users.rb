class AddStartingstock2ToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :startingstock2, :string
  end
end
