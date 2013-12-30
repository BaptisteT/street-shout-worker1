class Shout < ActiveRecord::Base
  attr_accessible   :description, :lat, :lng, :source, :created_at, :display_name, :device_id, :image, :is_born

  validates :description, presence: true, length: { maximum: 140 }
  validates :lat,         presence: true
  validates :lng,         presence: true
  validates :source,      presence: true
end
