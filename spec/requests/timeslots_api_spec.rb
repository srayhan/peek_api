require 'rails_helper'

RSpec.describe "Timeslots API" do

   describe 'POST /api/timeslots' do
      let(:defaults) { {format: :json} }
      let(:timeslot) { {start_time: Time.now.to_i, duration: 120} }

      it 'creates a timeslot with a starttime and duration' do
         post "/api/timeslots", {timeslot: timeslot}.merge(defaults)  
         expect(response).to be_success
         expect(response.body).to be_json_eql(timeslot.merge(id: 1, availability: 0, customer_count: 0, boats: []).to_json)
      end
   end

   describe 'GET /api/timeslots' do
      let(:defaults) { {format: :json} }
      let(:timeslot) { {start_time: Time.now.to_i, duration: 120} }

      it 'returns all timeslots for a given date' do
         FactoryGirl.create(:timeslot, {start_time: Date.today.to_time.to_i, duration: 120})
         FactoryGirl.create(:timeslot, {start_time: (Date.today+120.minutes).to_time.to_i, duration: 120})
         FactoryGirl.create(:timeslot, {start_time: (Date.today-120.minutes).to_time.to_i, duration: 120})
         get "/api/timeslots", {date: Date.today.strftime("%Y-%m-%d")}.merge(defaults)  
         expect(response).to be_success
         #expect(JSON.parse(response.body).count).to eq(2)
      end
   end
   
end