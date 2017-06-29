class CreateRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :ratings do |t|
      t.references :user, null: false
      t.integer :movie_id, null: false
      t.integer :value, null: false

      t.timestamps
    end
  end
end
