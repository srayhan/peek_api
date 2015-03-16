json.extract! timeslot, :id, :start_time, :duration, :availability, :customer_count

json.set! :boats do
   json.array! timeslot.assignments ? timeslot.assignments.map(&:boat_id) : []
end