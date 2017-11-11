class ListsController < ApplicationController
  def watched
    @movies = Movie.watched(current_user).page(params[:page])
  end

  def want_to_watch
    @movies = Movie.want_to_watch(current_user).page(params[:page])
  end

  def top_rated
    @movies = Movie.top_rated(current_user).page(params[:page])
  end
end
