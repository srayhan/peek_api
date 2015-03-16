class TimeslotsController < ApplicationController

   def index
      @timeslots = Timeslot.for_day(Date.strptime(params[:date], "%Y-%m-%d"))
   end

   def create
      if @timeslot = Timeslot.create(timeslot_params)
      else
         render json: @boat.errors, status: :bad_request
      end
   end

   private

   def timeslot_params
      params.require(:timeslot).permit(:start_time, :duration)
   end
end
