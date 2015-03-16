require 'rails_helper'

RSpec.describe "Boats API" do

   describe 'POST /api/boats' do
      let(:defaults) { {format: :json} }
      let(:boat) { {capacity: 8, name: 'Amazon Express'} }

      it 'creates a boat with capacity 8 and name Amazon Express' do
         post "/api/boats", {boat: boat}.merge(defaults)  
         expect(response).to be_success
         expect(response.body).to be_json_eql(boat.merge(id: 1).to_json)
      end
   end
   
end