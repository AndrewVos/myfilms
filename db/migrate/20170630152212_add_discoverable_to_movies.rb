class AddDiscoverableToMovies < ActiveRecord::Migration[5.1]
  def change
    add_column :movies, :discoverable, :boolean, default: false, null: false
  end
end
