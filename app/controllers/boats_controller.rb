class BoatsController < ApplicationController

   def index
      render json: Boat.all, status: :ok
   end

   def create
      if @boat = Boat.create(boat_params)
         render json: @boat, status: :ok
      else
         render json: @boat.errors, status: :bad_request
      end
   end

   private

   def boat_params
      params.require(:boat).permit(:name, :capacity)
   end

end
