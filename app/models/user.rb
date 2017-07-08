class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :ratings
  has_many :want_to_watches
  has_many :discovers

  validates :username, presence: true
  validates :username, uniqueness: true
  validates :username, format: {
    with: /\A[a-zA-Z0-9\-_.]+\z/,
    message: 'can only contain letters, numbers, hyphens, underscores, and periods'
  }
end
