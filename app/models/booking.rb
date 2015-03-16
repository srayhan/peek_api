class Booking < ActiveRecord::Base
   belongs_to :timeslot
   belongs_to :boat

   scope :for_timeslot, lambda {|timeslot| where(timeslot_id: timeslot.id) if timeslot}
end
