class AssignmentsController < ApplicationController

   def create
      if @assignment = Assignment.create(assignment_params)
         render nothing: true, status: :ok
      else
         render json: @assignment.errors, status: :bad_request
      end
   end

   private

   def assignment_params
      params.require(:assignment).permit(:boat_id, :timeslot_id, :status)
   end
end