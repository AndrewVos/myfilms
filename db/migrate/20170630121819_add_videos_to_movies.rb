class AddVideosToMovies < ActiveRecord::Migration[5.1]
  def change
    add_column :movies, :videos, :json
  end
end
