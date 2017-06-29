class HomeController < ApplicationController
  def index
    tmdb_ids = TheMovieDb
      .get_cached('/discover/movie?sort_by=popularity.desc')['results']
      .map {|m| m['id']}

    Movie.update_movies(tmdb_ids)

    @movies = Movie
      .where(tmdb_id: tmdb_ids)
      .with_user_data(current_user)
  end
end
