class DiscoveriesController < ApplicationController
  def show
    index = Integer(params[:id] || 0)

    @movie = Movie.discover(current_user)
      .offset(index)
      .limit(1)
      .first

    @next_discovery_path = discovery_path(index + 1)
  end
end
