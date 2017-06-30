class MoviesController < ApplicationController
  def show
    @movie = Movie.find(params[:id])
    @movie.retrieve_extra_details!
    @movie.with_user_data!(current_user) if current_user.present?
  end

  def search
    query = params[:q]

    if query.present?
      tmdb_response = TheMovieDb.get_cached(
        '/search/movie',
        query: { query: query }
      )

      Movie.create_from_tmdb_results(
        tmdb_response['results']
      )

      tmdb_ids = tmdb_response['results'].map { |r| r['id'] }

      @movies = Movie.where(tmdb_id: tmdb_ids)
      @movies = @movies.with_user_data(current_user) if current_user.present?
      @movies = Paginatable.new(
        current_page: params[:page],
        total_pages: tmdb_response['total_pages'],
        items: @movies,
      )
    else
      @movies = []
    end
  end
end
