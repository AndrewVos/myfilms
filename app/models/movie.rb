class Movie
  def initialize(options)
    @options = options

    options.each do |key, value|
      define_singleton_method key do
        value
      end
    end
  end

  def self.from_list_of_movie_db_movies(user, tmdb_movies)
    movies = tmdb_movies.map { |m| Movie.new(m) }

    return movies unless user.present?

    tmdb_movie_ids = tmdb_movies.map { |m| m['id'] }

    want_to_watches = user
      .want_to_watches
      .where(tmdb_id: tmdb_movie_ids)
      .pluck(:tmdb_id)

    ratings = user
      .ratings
      .where(tmdb_id: tmdb_movie_ids)
      .pluck(:tmdb_id, :value)
    ratings = Hash[*ratings.flatten]

    movies.each do |movie|
      movie.want_to_watch = want_to_watches.include?(movie.id)
      movie.rating = ratings[movie.id]
    end

    movies
  end

  def want_to_watch=(value)
    @want_to_watch = value
  end

  def want_to_watch?
    @want_to_watch
  end

  def rating=(value)
    @rating = value
  end

  def rating
    @rating
  end

  def imdb_url
    "http://www.imdb.com/title/#{imdb_id}/"
  end

  def poster_url
    return 'http://placehold.it/92x138' unless poster_path.present?
    "https://image.tmdb.org/t/p/w92#{poster_path}"
  end

  def large_poster_url
    return 'http://placehold.it/300x450' unless poster_path.present?
    "https://image.tmdb.org/t/p/w300#{poster_path}"
  end

  def title_with_year
    if year
      "#{title} (#{year})"
    else
      title
    end
  end

  def year
    if release_date.present?
      Date.parse(release_date).year
    else
      nil
    end
  end
end
