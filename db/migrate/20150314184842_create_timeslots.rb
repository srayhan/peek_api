class CreateTimeslots < ActiveRecord::Migration
  def change
      create_table :timeslots do |t|
      t.integer   :start_time, limit: 8, default: 0, null: false
      t.integer   :duration, default: 0
      t.integer   :lock_version, default: 0
      t.timestamps
      end

      add_index :timeslots, :start_time, :unique => true
  end
end
