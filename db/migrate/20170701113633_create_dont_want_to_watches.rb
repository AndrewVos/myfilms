class CreateDontWantToWatches < ActiveRecord::Migration[5.1]
  def change
    create_table :dont_want_to_watches do |t|
      t.references :user, null: false
      t.integer :movie_id, null: false

      t.timestamps
    end
  end
end
