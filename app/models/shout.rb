class Shout < ActiveRecord::Base
  attr_accessible   :description, :lat, :lng, :display_name, :source

  validates :description, presence: true, length: { maximum: 140 }
  validates :lat,         presence: true
  validates :lng,         presence: true
  validates :source,      presence: true
end
