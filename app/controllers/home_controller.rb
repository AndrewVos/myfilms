class HomeController < ApplicationController
  def index
    @popular = TheMovieDb
      .get_cached('/discover/movie?sort_by=popularity.desc')['results']

    @popular = Movie
      .from_list_of_movie_db_movies(current_user, @popular)
  end
end
