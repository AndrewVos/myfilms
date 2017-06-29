class WantToWatchesController < ApplicationController
  def toggle
    @tmdb_id = params[:movie_id]
    want_to_watch = current_user
      .want_to_watches
      .find_by(tmdb_id: @tmdb_id)

    if want_to_watch.present?
      want_to_watch.destroy!
    else
      current_user.want_to_watches.create!(tmdb_id: @tmdb_id)
    end
  end
end
