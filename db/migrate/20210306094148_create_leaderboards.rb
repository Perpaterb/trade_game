class CreateLeaderboards < ActiveRecord::Migration[6.1]
  def change
    create_table :leaderboards do |t|
      t.string :username, null: false
      t.float :net_worth, null: false

      t.timestamps
    end
  end
end
