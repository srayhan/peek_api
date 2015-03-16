require 'rails_helper'

RSpec.describe "Assignments API" do

   describe 'POST /api/assignments' do

      before :each do
         @boat = FactoryGirl.create(:boat, {capacity: 8, name: 'Amazon Express'})
         @timeslot = FactoryGirl.create(:timeslot, {start_time: 1406052000, duration: 120})
      end

      let(:defaults) { {format: :json} }
      let(:assignment) { {boat_id: @boat.id, timeslot_id: @timeslot.id} }

      it 'creates an assignment with a valid boat and timeslot id' do
         post "/api/assignments", {assignment: assignment}.merge(defaults)  
         expect(response).to be_success
         #expect(Assignment.where(boat_id: @boat_id, timeslot_id: @timeslot.id).count).to eq(1)
      end
   end
   
end