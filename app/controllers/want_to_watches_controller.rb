class WantToWatchesController < ApplicationController
  def toggle
    @movie_id = params[:movie_id]
    want_to_watch = current_user
      .want_to_watches
      .find_by(movie_id: @movie_id)

    if want_to_watch.present?
      want_to_watch.destroy!
    else
      current_user.want_to_watches.create!(movie_id: @movie_id)
    end
  end
end
