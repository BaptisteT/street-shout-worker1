class Shout < ActiveRecord::Base
  attr_accessible   :description, :lat, :lng, :source, :created_at, :username, :user_id, :image

  validates :description, presence: true, length: { maximum: 140 }
  validates :lat,         presence: true
  validates :lng,         presence: true
  validates :source,      presence: true
end
