class BookingsController < ApplicationController

   def create
      timeslot = Timeslot.find_by_id(params[:booking][:timeslot_id])
      if @booking = timeslot.book_a_boat(params[:booking][:size].to_i) #&& @booking.errors.empty?
         render nothing: true, status: :ok
      else
         render json: @booking.present? ? @booking.errors : 
                                          {message: "boat not available for this timeslot!"}, 
               status: :bad_request #400
      end
   end

end