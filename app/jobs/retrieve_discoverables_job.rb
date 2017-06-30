class RetrieveDiscoverablesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    1.upto(10) do |page|
      print "Retrieving page #{page}..."
      tmdb_response ||= TheMovieDb.get_cached(
        '/discover/movie?',
        query: {
          sort_by: 'popularity.desc',
          page: [page, Paginatable::MAX_PAGES].min,
        }
      )

      Movie.create_from_tmdb_results(
        tmdb_response['results']
      )

      tmdb_ids = tmdb_response['results'].map { |r| r['id'] }

      movies = Movie.where(tmdb_id: tmdb_ids)

      movies.each_with_index do |movie, index|
        movie.retrieve_extra_details!
        next unless movie.youtube_trailer_id.present?
        movie.update!(discoverable: true)
      end

      puts ' done'
    end
  end
end
