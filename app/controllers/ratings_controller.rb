class RatingsController < ApplicationController
  def rate
    @movie_id = params[:movie_id]
    @value = params[:rating][:value]

    rating = current_user
      .ratings
      .find_or_initialize_by(movie_id: @movie_id)

    rating.value = @value
    rating.save!
  end
end
