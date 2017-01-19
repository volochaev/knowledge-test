class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :ratings do |t|
      t.integer :post_id, null: false
      t.integer :one_star_count,    null: false, default: 0
      t.integer :two_stars_count,   null: false, default: 0
      t.integer :three_stars_count, null: false, default: 0
      t.integer :four_stars_count,  null: false, default: 0
      t.integer :five_stars_count,  null: false, default: 0

      t.integer :votes_count, null: false, default: 0
    end

    add_index :ratings, :post_id
  end
end
