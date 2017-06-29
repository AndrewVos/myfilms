class Movie < ApplicationRecord
  has_many :ratings
  has_many :want_to_watches

  def self.update_movies(tmdb_ids)
    existing_ids = Movie.where(tmdb_id: tmdb_ids).pluck(:tmdb_id)
    to_update = tmdb_ids - existing_ids

    to_update.each do |tmdb_id|
      json = TheMovieDb.get_cached("/movie/#{tmdb_id}")
      json['tmdb_id'] = json['id']
      json.except!(
        'id',
        'belongs_to_collection',
        'genres',
        'production_companies',
        'production_countries',
        'spoken_languages'
      )
      create!(json)
    end
  end

  def user_rating
    attributes['user_rating']
  end

  def user_want_to_watch?
    attributes['user_want_to_watch']
  end

  def self.watched(user)
    includes(:ratings)
      .where(ratings: { user: user })
      .order('ratings.created_at DESC')
  end

  def self.want_to_watch(user)
    includes(:want_to_watches)
      .where(want_to_watches: { user: user })
      .order('want_to_watches.created_at DESC')
  end

  def self.with_user_data(user)
    joins(
      <<-SQL
        LEFT OUTER JOIN ratings
          ON
            ratings.movie_id = movies.id
          AND
            ratings.user_id = #{user.id}
    SQL
  )
    .joins(
      <<-SQL
        LEFT OUTER JOIN want_to_watches
          ON
            want_to_watches.movie_id = movies.id
          AND
            want_to_watches.user_id = #{user.id}
      SQL
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
      Date.parse(release_date).year
    else
      nil
    end
  end
end
