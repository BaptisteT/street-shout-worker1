class ScheduledShout < ActiveRecord::Base
  attr_accessible   :description, :lat, :lng, :scheduled_time, :display_name, :author, :avatar
  attr_accessor :password, :is_born
  
  validates :description, presence: true, length: { maximum: 140 }
  validates :display_name, presence: true, length: { maximum: 20 }
  validates :lat,         presence: true
  validates :lng,         presence: true
  validates :is_valid_time?
  validates :author, presence: true

 with_options :if => :is_born do |shout|
   shout.validates :lat, :numericality => { :greater_than => BORN_LAT_MIN, :less_than_or_equal_to => BORN_LAT_MAX,
                                                                              :message => " - This is not in the 3 Vallees" } 
   shout.validates :lng, :numericality => { :greater_than => BORN_LONG_MIN, :less_than_or_equal_to => BORN_LONG_MAX,
                                                                              :message => " - This is not in the 3 Vallees" }  
 end

  Paperclip.interpolates :file_name do |attachment, style|
    attachment.instance.id.to_s + "--400"
  end

  # This method associates the attribute ":avatar" with a file attachment
  has_attached_file :avatar, styles: {
    square: '400x400#'
  },
  path: ":style/:file_name"

  private

  def is_valid_time?
    # if ! scheduled_time.is_a?(Date)
    #   errors.add(:scheduled_time,'must be a valid date')
    # end
    # if :scheduled_time < Time.now
    #   errors.add(:scheduled_time,'must be in the future')
    # end
  end
end
