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
    if params[:scheduled_shout][:password] == "shoutouillons"
        shout_date_time = DateTime.new(params[:scheduled_shout]["scheduled_time(1i)"].to_i, 
                                    params[:scheduled_shout]["scheduled_time(2i)"].to_i,
                                    params[:scheduled_shout]["scheduled_time(3i)"].to_i,
                                    params[:scheduled_shout]["scheduled_time(4i)"].to_i,
                                    params[:scheduled_shout]["scheduled_time(5i)"].to_i)

        params[:scheduled_shout][:scheduled_time] = shout_date_time

        @scheduled_shout = ScheduledShout.new(params[:scheduled_shout])

        respond_to do |format|
          if @scheduled_shout.save
            format.html { render root_path, notice: 'You rock!' }
          else
            format.html { render root_path, notice: 'Bad luck, it failed...' }
          end
        end
    else 
        format.html { render root_path, notice: 'Wrong password dude, get outta here!!!' }    
    end 
  end
end
