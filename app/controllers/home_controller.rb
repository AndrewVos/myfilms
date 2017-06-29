class HomeController < ApplicationController
  def index
    @popular = TheMovieDb
      .get_cached('/discover/movie?sort_by=popularity.desc')['results']
      .map { |m| Movie.new(m) }

    want_to_watches = current_user
      .want_to_watches
      .where(tmdb_id: @popular.map(&:id))
      .pluck(:tmdb_id)

    ratings = current_user
      .ratings
      .where(tmdb_id: @popular.map(&:id))
      .pluck(:tmdb_id, :value)
    ratings = Hash[*ratings.flatten]

    @popular.each do |movie|
      movie.want_to_watch = want_to_watches.include?(movie.id)
      movie.rating = ratings[movie.id]
    end
  end
end
