require 'securerandom'

class ShortenedUrl < ApplicationRecord
  validates :long_url, presence: true
  validates :short_url, presence: true, uniqueness: true

  def self.random_code
    url = SecureRandom.urlsafe_base64
    while self.exists?(short_url: url)
      url = SecureRandom.urlsafe_base64
    end
    url
  end

  def self.make_shortened_url(user, long_url) 
    ShortenedUrl.create!(long_url: long_url, short_url: self.random_code, user_id: user.id)
  end

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.visitors.select(:user_id).count
  end

  def num_recent_uniques
    self.visits.where(updated_at: 10.minutes.ago..Time.now).select(:user_id).distinct.count
  end

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: "User"

  has_many :visits,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: "Visit"

  has_many :visitors,
    -> {distinct},
    through: :visits,
    source: :visitor
end