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
