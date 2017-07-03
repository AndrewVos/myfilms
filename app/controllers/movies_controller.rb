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

  def toggle_want_to_watch
    @movie = Movie.find(params[:movie_id])

    want_to_watch = current_user
      .want_to_watches
      .find_by(movie: @movie)

    if want_to_watch.present?
      want_to_watch.destroy!
    else
      current_user.want_to_watches.create!(movie: @movie)
    end

    @movie.with_user_data!(current_user)
  end

  def discover
    index = Integer(params[:id] || 0)

    movies = Movie.discover(current_user)

    if user_signed_in?
      @movie = movies.limit(1).first
      @movie.with_user_data!(current_user) if current_user.present?
      @movie.watched!(current_user) if current_user.present?
    else
      @movie = movies.order('random()').limit(1).first
    end
  end

  def rate
    @movie = Movie.find(params[:movie_id])
    @value = params[:rating][:value]

    rating = current_user
      .ratings
      .find_or_initialize_by(movie: @movie)
    rating.value = @value
    rating.save!
    @movie.with_user_data!(current_user) if current_user.present?
  end
end
