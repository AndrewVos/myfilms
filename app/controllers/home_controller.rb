class HomeController < ApplicationController
  def index
    Movie.create_from_tmdb_results(tmdb_results)

    tmdb_ids = tmdb_results.map { |r| r['id'] }

    @movies = Movie.where(tmdb_id: tmdb_ids)
    @movies = @movies.with_user_data(current_user) if current_user.present?
    @movies = Paginatable.new(params, tmdb_response, @movies)
  end

  private

  def tmdb_response
    @tmdb_response ||= TheMovieDb.get_cached(
      '/discover/movie?',
      query: {
        sort_by: 'popularity.desc',
        page: [Integer(params[:page] || 1), Paginatable::MAX_PAGES].min,
      }
    )
  end

  def tmdb_results
    tmdb_response['results']
  end
end
