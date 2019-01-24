class Visit < ApplicationRecord
  validates :user_id, presence: true
  validates :url_id, presence: true

  belongs_to :visited_url,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: "ShortenedUrl"
  
  belongs_to :visitor,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: "User"

  def self.record_visit(user, shortened_url)
    self.create!(user_id: user.id, url_id: shortened_url.id)
  end

end