class Paginatable
  MAX_PAGES = 1000

  attr_reader :current_page
  attr_reader :total_pages
  attr_reader :limit_value
  attr_reader :items

  delegate :each, to: :items

  def initialize(params, tmdb_response, items)
    @current_page = ([Integer(params[:page] || 1), MAX_PAGES]).min
    @total_pages = [tmdb_response['total_pages'], 1000].min
    @limit_value = 20
    @items = items
  end
end
