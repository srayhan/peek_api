class CreateBookings < ActiveRecord::Migration
  def change
      create_table :bookings do |t|
         t.integer   :timeslot_id
         t.integer   :boat_id
         t.integer   :size, default: 0
         t.timestamps
      end

      add_index :bookings, :timeslot_id
      add_index :bookings, :boat_id
  end
end
