class AddStartingstock4ToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :startingstock4, :string
  end
end
