class CreateBoats < ActiveRecord::Migration
  def change
    create_table :boats do |t|
      t.string    :name
      t.integer   :capacity, default: 0
      t.timestamps
    end

    add_index :boats, :name
    add_index :boats, :capacity
  end
end
