class MoviesController < ApplicationController
  def show
    @movie = Movie.find(params[:id])
    @movie.retrieve_extra_details!
    @movie.with_user_data!(current_user) if current_user.present?
  end
end
