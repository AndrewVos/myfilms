require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  def setup
    @movie = Movie.create!(tmdb_id: 123)
    @user = User.create!(email: 'test@test.com', password: 'password', username: 'something')
  end

  test '.with_user_data includes user rating' do
    @user.ratings.create!(movie: @movie, value: 5)

    all = Movie.all.with_user_data(@user)

    assert_equal(5, all.first.user_rating)
  end

  test '.with_user_data does not include other users ratings' do
    User
      .create!(email: 'other@test.com', password: 'password', username: 'something-else')
      .ratings.create!(movie: @movie, value: 5)

    all = Movie.all.with_user_data(@user)

    assert_nil(all.first.user_rating)
  end

  test '.with_user_data includes user want to watch' do
    @user.want_to_watches.create!(movie: @movie)

    all = Movie.all.with_user_data(@user)

    assert(all.first.user_want_to_watch?)
  end

  test '.with_user_data does not include other users want to watch' do
    User
      .create!(email: 'other@test.com', password: 'password', username: 'something-else')
      .want_to_watches.create!(movie: @movie)

    all = Movie.all.with_user_data(@user)

    refute(all.first.user_want_to_watch?)
  end

  test '.with_user_data includes user_discovered?' do
    @user
      .discovers
      .create!(movie: @movie)

    all = Movie.all.with_user_data(@user)

    assert(all.first.user_discovered?)
  end

  test '.with_user_data does not include other user_discovered?' do
    User
      .create!(email: 'other@test.com', password: 'password', username: 'something-else')
      .discovers.create!(movie: @movie)

    all = Movie.all.with_user_data(@user)

    refute(all.first.user_discovered?)
  end

  test '.top_rated includes only top rated movies' do
    movie1 = Movie.create!(tmdb_id: 123)
    movie2 = Movie.create!(tmdb_id: 456)

    @user
      .ratings
      .create!(movie: movie1, value: 1)

    @user
      .ratings
      .create!(movie: movie2, value: 4)

    top_rated = Movie.top_rated(@user).to_a

    assert_equal(1, top_rated.size)
    assert_equal(movie2, top_rated.first)
  end
end
