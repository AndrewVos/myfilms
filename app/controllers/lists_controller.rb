class ListsController < ApplicationController
  def watched
    @movies = Movie.watched(current_user)
  end

  def want_to_watch
    @movies = Movie.want_to_watch(current_user)
  end
end
