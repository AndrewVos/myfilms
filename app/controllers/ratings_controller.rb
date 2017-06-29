class RatingsController < ApplicationController
  def rate
    @tmdb_id = params[:movie_id]
    @value = params[:rating][:value]

    rating = current_user
      .ratings
      .find_or_initialize_by(tmdb_id: @tmdb_id)

    rating.value = @value
    rating.save!
  end
end
