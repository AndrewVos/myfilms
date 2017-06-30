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

  def discover
    discovery = Movie.next_discovery(current_user)
    redirect_to movie_discovery_path(
      discovery[:movie],
      page: discovery[:page]
    )
  end

  def discovery
    @movie = Movie.find(params[:movie_id])
    @movie.retrieve_extra_details!
    @movie.with_user_data!(current_user) if current_user.present?

    next_discovery = Movie.next_discovery(
      current_user,
      page: params[:page],
      index: params[:index]
    )

    @next_discovery_path = movie_discovery_path(
      next_discovery[:movie],
      page: next_discovery[:page],
      index: next_discovery[:index],
    )
  end
end
