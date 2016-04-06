class CreateActivityEvents < ActiveRecord::Migration
  def change
    create_table :activity_events do |t|
      t.integer :activity_id
      t.integer :event_id
    end
  end
end
