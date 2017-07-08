class HomeController < ApplicationController
  def index
    @movies = Movie.discover(current_user)
    @movies = @movies.with_user_data(current_user) if user_signed_in?
    @movies = @movies.page(params[:page])
  end
end
