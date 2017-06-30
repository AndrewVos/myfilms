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

  def self.random_high_rated(user)
    watched(user)
      .where('ratings.value > 3')
      .sample(1)
      .first
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
