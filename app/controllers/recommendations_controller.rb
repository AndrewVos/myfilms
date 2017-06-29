class RecommendationsController < ApplicationController
  def index
    movie = Movie.random_high_rated(current_user)
    tmdb_results = TheMovieDb
      .get_cached("/movie/#{movie.tmdb_id}/recommendations")['results']

    Movie.create_from_tmdb_results(tmdb_results)

    tmdb_ids = tmdb_results.map { |r| r['id'] }

    @movies = Movie.where(tmdb_id: tmdb_ids)
    @movies = @movies.with_user_data(current_user) if current_user.present?
  end
end
