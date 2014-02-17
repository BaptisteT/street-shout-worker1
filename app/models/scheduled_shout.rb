class ScheduledShout < ActiveRecord::Base
  attr_accessible   :description, :lat, :lng, :scheduled_time, :display_name, :author, :avatar
  attr_accessor :password
  
  validates :description, presence: true, length: { maximum: 140 }
  validates :display_name, presence: true, length: { maximum: 20 }
  validates :lat,         presence: true
  validates :lng,         presence: true
  validate  :is_future_time?
  validates :author, presence: true

  Paperclip.interpolates :file_name do |attachment, style|
    attachment.instance.id.to_s + "--400"
  end

  # This method associates the attribute ":avatar" with a file attachment
  has_attached_file :avatar, styles: {
    square: '400x400#'
  },
  path: ":style/:file_name"

  private

  def is_future_time?
    if scheduled_time < Time.now
      errors.add(:scheduled_time,'Scheduled time must be in the future')
    end
  end
end
