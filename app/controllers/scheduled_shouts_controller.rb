class ScheduledShoutsController < ApplicationController

  # GET /scheduled_shouts/new
  def new
    @scheduled_shout = ScheduledShout.new
    @scheduled_shouts = ScheduledShout.all

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

    params[:scheduled_shout][:scheduled_time] = shout_date_time
    @scheduled_shout = ScheduledShout.new(params[:scheduled_shout])
    if params[:scheduled_shout][:password] == "shoutouillons"
      respond_to do |format|
        if @scheduled_shout.save
          @notice = 'You rock!'
          format.html { redirect_to root_url }
        else
          @notice = 'Bad luck, it failed...' 
          format.html { redirect_to root_url }
        end
      end
    else 
      respond_to do |format|
        @notice = 'Wrong password dude, get outta here!!!'
        format.html { redirect_to root_url }   
      end 
    end 
  end

  # DELETE /scheduled_shouts/1
  def destroy
    @scheduled_shout = ScheduledShout.find(params[:id])
    @scheduled_shout.destroy

    respond_to do |format|
      @notice = 'Scheduled shout deleted!' 
      format.html { redirect_to root_url }
    end
  end
end
