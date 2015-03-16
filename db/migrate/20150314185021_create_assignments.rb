class CreateAssignments < ActiveRecord::Migration
  def change
      create_table :assignments do |t|
         t.integer   :timeslot_id
         t.integer   :boat_id
         t.string    :status, default: "AVAILABLE"
         t.integer   :lock_version, default: 0
         t.timestamps
      end

      add_index :assignments, :timeslot_id
      add_index :assignments, :boat_id
      add_index :assignments, :status
  end
end
