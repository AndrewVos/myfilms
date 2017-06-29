class HomeController < ApplicationController
  def index
    tmdb_results = TheMovieDb
      .get_cached('/discover/movie?sort_by=popularity.desc')['results']

    Movie.create_from_tmdb_results(tmdb_results)

    tmdb_ids = tmdb_results.map { |r| r['id'] }

    @movies = Movie.where(tmdb_id: tmdb_ids)
    @movies = @movies.with_user_data(current_user) if current_user.present?
  end
end
