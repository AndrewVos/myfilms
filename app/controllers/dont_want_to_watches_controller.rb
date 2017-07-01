class DontWantToWatchesController < ApplicationController
  def toggle
    @movie_id = params[:movie_id]
    dont_want_to_watch = current_user
      .dont_want_to_watches
      .find_by(movie_id: @movie_id)

    if dont_want_to_watch.present?
      dont_want_to_watch.destroy!
    else
      current_user.dont_want_to_watches.create!(movie_id: @movie_id)
    end
  end
end
