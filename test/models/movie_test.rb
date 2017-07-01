require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  def setup
    @movie = Movie.create!(tmdb_id: 123)
    @user = User.create!(email: 'test@test.com', password: 'password')
  end

  test '.with_user_data includes user rating' do
    @user.ratings.create!(movie: @movie, value: 5)

    all = Movie.all.with_user_data(@user)

    assert_equal(5, all.first.user_rating)
  end

  test '.with_user_data does not include other users ratings' do
    User
      .create!(email: 'other@test.com', password: 'password')
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
      .create!(email: 'other@test.com', password: 'password')
      .want_to_watches.create!(movie: @movie)

    all = Movie.all.with_user_data(@user)

    refute(all.first.user_want_to_watch?)
  end

  test '.with_user_data includes user dont want to watch' do
    @user.dont_want_to_watches.create!(movie: @movie)

    all = Movie.all.with_user_data(@user)

    assert(all.first.user_dont_want_to_watch?)
  end

  test '.with_user_data does not include other users dont want to watch' do
    User
      .create!(email: 'other@test.com', password: 'password')
      .dont_want_to_watches.create!(movie: @movie)

    all = Movie.all.with_user_data(@user)

    refute(all.first.user_dont_want_to_watch?)
  end
end
