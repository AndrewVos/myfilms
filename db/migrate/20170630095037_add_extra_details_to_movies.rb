class AddExtraDetailsToMovies < ActiveRecord::Migration[5.1]
  def change
    add_column :movies, :budget, :integer
    add_column :movies, :genres, :json
    add_column :movies, :imdb_id, :string
    add_column :movies, :popularity, :decimal
    add_column :movies, :revenue, :integer
    add_column :movies, :runtime, :integer
    add_column :movies, :spoken_languages, :json
    add_column :movies, :status, :string
    add_column :movies, :tagline, :string
  end
end
