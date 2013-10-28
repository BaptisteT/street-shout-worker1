class ScheduledShout < ActiveRecord::Base
  attr_accessible   :description, :lat, :lng, :schedule_time, :display_name, :image, :author
  
  validates :description, presence: true, length: { maximum: 140 }
  validates :display_name, presence: true, length: { maximum: 20 }
  validates :lat,         presence: true
  validates :lng,         presence: true
  validates :scheduled_time,      presence: true
  validates :author, presence: true
end