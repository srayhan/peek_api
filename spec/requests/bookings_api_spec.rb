require 'rails_helper'

RSpec.describe "Bookings API" do

   describe "POST /api/bookings" do

      context "given two boats assigned to a timeslot (case 1 extended)" do

         before :each do
            boat1 = FactoryGirl.create(:boat, {capacity: 8, name: 'Amazon Express'})
            boat2 = FactoryGirl.create(:boat, {capacity: 4, name: 'Amazon Express Mini'})
            @timeslot = FactoryGirl.create(:timeslot, {start_time: 1406052000, duration: 120})
            FactoryGirl.create(:assignment, {timeslot_id: @timeslot.id, boat_id: boat1.id})
            FactoryGirl.create(:assignment, {timeslot_id: @timeslot.id, boat_id: boat2.id})
         end

         let(:defaults) { {format: :json} }
         let(:booking) { {timeslot_id: @timeslot.id, size: 6} }
         let(:test_date) {"2014-07-22"}

         it "creates first booking for the timeslot" do
            post "/api/bookings", {booking: booking}.merge(defaults) 
            expect(response).to be_success
            get "/api/timeslots", {date: test_date}.merge(defaults)  
            expect(response).to be_success
            timeslots = JSON.parse(response.body)
            expect(timeslots[0]["availability"]).to eq(4)
            expect(timeslots[0]["customer_count"]).to eq(6)
         end

         it "creates a second booking for the timeslot" do
            @timeslot.book_a_boat(6)
            booking[:size] = 4
            post "/api/bookings", {booking: booking}.merge(defaults) 
            expect(response).to be_success
            get "/api/timeslots", {date: test_date}.merge(defaults)  
            expect(response).to be_success
            timeslots = JSON.parse(response.body)
            expect(timeslots[0]["availability"]).to eq(2)
            expect(timeslots[0]["customer_count"]).to eq(10)
         end

         it "booking fails when party size > availablity for the timeslot" do
            booking[:size] = 9
            post "/api/bookings", {booking: booking}.merge(defaults) 
            expect(response).to have_http_status(400)
            get "/api/timeslots", {date: test_date}.merge(defaults)  
            expect(response).to be_success
            timeslots = JSON.parse(response.body)
            expect(timeslots[0]["availability"]).to eq(8)
            expect(timeslots[0]["customer_count"]).to eq(0)
         end

      end

      context "given a boat assigned to two overlapping timeslots (case 2)" do

         before :each do
            boat = FactoryGirl.create(:boat, {capacity: 8, name: 'Amazon Express'})
            @timeslot1 = FactoryGirl.create(:timeslot, {start_time: 1406052000, duration: 120})
            @timeslot2 = FactoryGirl.create(:timeslot, {start_time: 1406055600, duration: 120})
            FactoryGirl.create(:assignment, {timeslot_id: @timeslot1.id, boat_id: boat.id})
            FactoryGirl.create(:assignment, {timeslot_id: @timeslot2.id, boat_id: boat.id})
         end

         let(:defaults) { {format: :json} }
         let(:booking) { {timeslot_id: @timeslot2.id, size: 6} }
         let(:test_date) {"2014-07-22"}

         it "creates a booking for one timeslot and makes the boat unavilable for the other" do
            #befoe booking
            get "/api/timeslots", {date: test_date}.merge(defaults)  
            expect(response).to be_success
            timeslots = JSON.parse(response.body)
            expect(timeslots.count).to eq(2)
            expect(timeslots[0]["availability"]).to eq(8)
            expect(timeslots[0]["customer_count"]).to eq(0)
            expect(timeslots[1]["availability"]).to eq(8)
            expect(timeslots[1]["customer_count"]).to eq(0)

            post "/api/bookings", {booking: booking}.merge(defaults) 
            expect(response).to be_success

            #after booking
            get "/api/timeslots", {date: test_date}.merge(defaults)  
            expect(response).to be_success
            timeslots = JSON.parse(response.body)
            expect(timeslots.count).to eq(2)
            #timeslots should be in ASC order
            expect(timeslots[0]["availability"]).to eq(0)
            expect(timeslots[0]["customer_count"]).to eq(0)
            expect(timeslots[1]["availability"]).to eq(2)
            expect(timeslots[1]["customer_count"]).to eq(6)
         end

      end
   end
end