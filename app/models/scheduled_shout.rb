class ScheduledShout < ActiveRecord::Base
  attr_accessible   :description, :lat, :lng, :scheduled_time, :display_name, :author, :avatar, :is_born
  attr_accessor :password
  
  validates :description, presence: true, length: { maximum: 140 }
  validates :display_name, presence: true, length: { maximum: 20 }
  validates :lat,         presence: true
  validates :lng,         presence: true
  validates :scheduled_time,      presence: true, :numericality => 
                          {:greater_than => Proc.new{|r| Time.now}, :message => "the date should be in the future"}
  validates :author, presence: true

 # with_options :if => :is_born do |shout|
 #   shout.validates :lat, :numericality => { :greater_than => BORN_LAT_MIN, :less_than_or_equal_to => BORN_LAT_MAX,
 #                                                                             :message => "This is not in the 3 Vallees"} 
 #   shout.validates :long, :numericality => { :greater_than => BORN_LONG_MIN, :less_than_or_equal_to => BORN_LONG_MAX,
 #                                                                             :message => "This is not in the 3 Vallees"}  
 # end

  Paperclip.interpolates :file_name do |attachment, style|
    attachment.instance.id.to_s + "--400"
  end

  # This method associates the attribute ":avatar" with a file attachment
  has_attached_file :avatar, styles: {
    square: '400x400#'
  },
  path: ":style/:file_name"
end
