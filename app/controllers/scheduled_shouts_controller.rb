class ScheduledShoutsController < ApplicationController

  # GET /scheduled_shouts/new
  def new
    @scheduled_shout = ScheduledShout.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /scheduled_shouts
  def create
  	# shout_date_time = DateTime.new(params["scheduled_time(1i)"].to_i, 
   #                      params["scheduled_time(2i)"].to_i,
   #                      params["scheduled_time(3i)"].to_i,
   #                      params["scheduled_time(4i)"].to_i,
   #                      params["scheduled_time(5i)"].to_i)

Rails.logger.info "BAB Scheduled time = #{params[:scheduled_shout][:scheduled_time]}"

  	params[:scheduled_time] = shout_date_time

    @scheduled_shout = ScheduledShout.new(params[:scheduled_shout])

    respond_to do |format|
      if @scheduled_shout.save
        format.html { render action: "new", notice: 'Shout was successfully scheduled.' }
      else
        format.html { render action: "new" }
      end
    end
  end
end
