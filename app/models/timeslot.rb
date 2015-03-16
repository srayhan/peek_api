class Timeslot < ActiveRecord::Base
   has_many :bookings,  -> { order(boat_id: :asc) }
   has_many :assignments, -> { where("status != ?", 'UNAVAILABLE').order(boat_id: :asc) }
   has_many :boats_assigned, through: :assignments, source: :boat
   has_many :boats_booked, through: :bookings, source: :boat

   scope :for_day, lambda { |date| where(" start_time >= ? AND  start_time <= ?", date.to_time.to_i, (date+1.day).to_time.to_i) }

    validates :duration, presence: true, :numericality => { :only_integer => true }
    validates :start_time, presence: true, :numericality => { :only_integer => true }

   def as_json(options={})
      options[:except] ||= [:lock_version, :created_at, :updated_at]
      super
   end

   def boats_not_booked
      boats_assigned - boats_booked
   end

   def availability
      max_availability
   end

   def customer_count
      bookings.map(&:size).reduce(:+) || 0
   end

   def book_a_boat(party_size)
      self.transaction do
         if boat = first_available_boat(party_size)
            booking = Booking.create(timeslot_id: self.id, boat_id: boat.id, size: party_size) 
            update({availability: max_availability, customer_count: (customer_count+party_size)})
            booking
         end
      end
   end

   #
   # rule: Cannot split a party across boats!
   # rule: a boat assigned to overlapping timeslots, can only be booked against one timeslot 
   def first_available_boat(party_size)
      boats_assigned.each do |boat|
         if (boat.availability(self) - party_size) >= 0 && boat.assignments.overlapping(self).booked.count == 0
            boat.assignments.overlapping(self).update_all(status: 'UNAVAILABLE')
            self.assignments.detect{|a| a.boat_id == boat.id}.update(status: 'BOOKED')
            return boat
         end
      end
      nil
   end

   def max_availability
      [boats_booked.map{|b| b.availability(self)}.max || 0, boats_not_booked.map(&:capacity).max || 0].max 
   end
end
