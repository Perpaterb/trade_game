class AddStartingstock3ToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :startingstock3, :string
  end
end
