class RecommendationsController < ApplicationController
  def index
    tmdb_response = TheMovieDb
      .get_cached("/movie/#{random_movie.tmdb_id}/recommendations")

    Movie.create_from_tmdb_results(tmdb_response['results'])

    tmdb_ids = tmdb_response['results'].map { |r| r['id'] }

    @movies = Movie.where(tmdb_id: tmdb_ids)
    @movies = @movies.with_user_data(current_user) if current_user.present?
    @movies = Paginatable.new(
      current_page: params[:page],
      total_pages: tmdb_response['total_pages'],
      items: @movies
    )
  end

  private

  def random_movie
    @random_movie ||= Movie.random_high_rated(current_user)
  end
end
