class CreateLeaderboards < ActiveRecord::Migration[6.1]
  def change
    create_table :leaderboards do |t|
      t.integer :user_id, null: false
      t.float :net_worth, null: false

      t.timestamps
    end
  end
end
