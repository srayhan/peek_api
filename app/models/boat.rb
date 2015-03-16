class Boat < ActiveRecord::Base

   has_many :assignments
   has_many :bookings

   validates :name, presence: true
   validates :capacity, presence: true, :numericality => { :only_integer => true }

   def as_json(options={})
      options[:except] ||= [:created_at, :updated_at]
      super
   end

   def availability(timeslot)
      bookings.present? ? capacity - bookings.for_timeslot(timeslot).map(&:size).reduce(:+) : capacity
   end

end
