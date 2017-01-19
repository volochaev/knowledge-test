class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string  :title,     null: false
      t.text    :body,      null: false
      t.integer :user_id,   null: false
      t.inet    :author_ip, null: false
      t.float   :weighted_average, null: false, default: 0.0, scale: 3, precision: 2

      t.timestamps
    end

    add_index :posts, :author_ip
    add_index :posts, :weighted_average
  end
end
