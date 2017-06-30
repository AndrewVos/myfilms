class Paginatable
  MAX_PAGES = 1000

  attr_reader :current_page
  attr_reader :total_pages
  attr_reader :limit_value
  attr_reader :items

  delegate :each, to: :items

  def initialize(current_page:, total_pages:, items:)
    @current_page = ([Integer(current_page || 1), MAX_PAGES]).min
    @total_pages = [Integer(total_pages), 1000].min
    @limit_value = 20
    @items = items
  end
end
