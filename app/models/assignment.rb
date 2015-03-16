class Assignment < ActiveRecord::Base
   belongs_to :timeslot
   belongs_to :boat

   STATUSES = %w(AVAILABLE BOOKED UNAVAILABLE)

   scope :available, -> { where(status: 'AVAILABLE')}
   scope :booked, -> { where(status: 'BOOKED')}
   scope :unavailable, -> { where(status: 'UNAVAILABLE')}
   scope :overlapping, -> (timeslot) { joins(:timeslot)
                              .where("start_time >= ? AND start_time <= ? AND timeslot_id != ?", timeslot.start_time-(timeslot.duration * 60),
                                      timeslot.start_time+(timeslot.duration * 60), timeslot.id) }

   validates :boat_id, :timeslot_id, presence: true

   def as_json(options={})
      options[:except] ||= [:lock_version, :created_at, :updated_at]
      super
   end
end
