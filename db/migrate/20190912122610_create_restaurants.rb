class CreateRestaurants < ActiveRecord::Migration[6.0]
  def change
    create_table :restaurants do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :name
      t.string :posts_count

      t.timestamps
    end
  end
end
