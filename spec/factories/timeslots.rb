FactoryGirl.define do
  factory :timeslot do
      duration 120
      sequence :start_time  do |n|
         Time.now.to_i + (120 *  60 * n)
      end
  end
end