class TheMovieDb
  include HTTParty

  base_uri 'https://api.themoviedb.org/3'
  default_params api_key: ENV.fetch('THE_MOVIE_DB_API_KEY')

  logger Rails.logger

  def self.get_cached(url, options={})
    key = Digest::MD5.hexdigest("#{url}#{options.to_json}")
    Rails.cache.fetch(key, expires_in: 12.hours) do
      get(url, options).parsed_response
    end
  end
end
