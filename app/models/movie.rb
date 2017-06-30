class Movie < ApplicationRecord
  has_many :ratings
  has_many :want_to_watches

  def self.create_from_tmdb_results(tmdb_results)
    tmdb_results.each do |tmdb_result|
      movie = Movie.find_or_initialize_by(tmdb_id: tmdb_result['id'])

      movie.assign_attributes(
        tmdb_result
          .merge('tmdb_id': tmdb_result['id'])
          .except('id', 'popularity', 'genre_ids')
      )
      movie.save!
    end
  end

  def with_user_data!(user)
    @user_rating = user
      .ratings
      .where(movie: self)
      .first
      .try(:value)

    @user_want_to_watch = user
      .want_to_watches
      .where(movie: self)
      .any?
  end

  def retrieve_extra_details!
    details = TheMovieDb.get_cached(
      "/movie/#{tmdb_id}",
      query: { append_to_response: 'videos' }
    )

    self.update!(
      details.except(
        'id',
        'belongs_to_collection',
        'homepage',
        'production_companies',
        'production_countries'
      ).merge(videos: details['videos']['results'])
    )
  end

  def youtube_trailer_id
    return nil unless videos.present?

    best_match = nil

    videos.each do |video|
      if video['site'] == 'YouTube' && video['type'] == 'Trailer'
        best_match = video['key']
        return best_match if video['name'].downcase.include?('official')
      end
    end

    best_match
  end

  def genre_names
    return [] unless genres.present?

    genres.map {|g| g['name']}
  end

  def language_names
    return [] unless spoken_languages.present?

    spoken_languages.map {|l| l['name']}
  end

  def user_rating
    @user_rating || attributes['user_rating']
  end

  def user_want_to_watch?
    @user_want_to_watch || attributes['user_want_to_watch']
  end

  def self.discover(user)
    joins("LEFT OUTER JOIN ratings ON ratings.movie_id = movies.id AND ratings.user_id = #{user.id}")
      .joins("LEFT OUTER JOIN want_to_watches ON want_to_watches.movie_id = movies.id AND want_to_watches.user_id = #{user.id}")
      .where('ratings.id IS NULL')
      .where('want_to_watches.id IS NULL')
  end

  def self.watched(user)
    includes(:ratings)
      .where(ratings: { user: user })
      .order('ratings.created_at DESC')
      .with_user_data(user)
  end

  def self.want_to_watch(user)
    includes(:want_to_watches)
      .where(want_to_watches: { user: user })
      .order('want_to_watches.created_at DESC')
      .with_user_data(user)
  end

  def self.with_user_data(user)
    joins(
      "LEFT OUTER JOIN ratings ON ratings.movie_id = movies.id AND ratings.user_id = #{user.id}"
    )
    .joins(
      "LEFT OUTER JOIN want_to_watches ON want_to_watches.movie_id = movies.id AND want_to_watches.user_id = #{user.id}"
    )
    .select('movies.*, ratings.value AS user_rating, want_to_watches.id > 0 AS user_want_to_watch')
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
      release_date.year
    else
      nil
    end
  end
end
