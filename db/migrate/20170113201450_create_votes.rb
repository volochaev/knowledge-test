class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.integer :post_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end

    add_index :votes, [:post_id, :user_id]
  end
end
