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
    shout_date_time = DateTime.new(params[:scheduled_shout]["scheduled_time(1i)"].to_i, 
                                params[:scheduled_shout]["scheduled_time(2i)"].to_i,
                                params[:scheduled_shout]["scheduled_time(3i)"].to_i,
                                params[:scheduled_shout]["scheduled_time(4i)"].to_i,
                                params[:scheduled_shout]["scheduled_time(5i)"].to_i)

    @scheduled_shout = ScheduledShout.new(params[:scheduled_shout][:author],
                                        params[:scheduled_shout][:lat],
                                        params[:scheduled_shout][:lng],
                                        shout_date_time,
                                        params[:scheduled_shout][:description],
                                        params[:scheduled_shout][:display_name],
                                        params[:scheduled_shout][:image])

    respond_to do |format|
      if @scheduled_shout.save
        format.html { render action: "new", notice: 'Shout was successfully scheduled.' }
      else
        format.html { render action: "new" }
      end
    end
  end
end
