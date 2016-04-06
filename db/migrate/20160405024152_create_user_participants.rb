class CreateUserParticipants < ActiveRecord::Migration
  def change
    create_table :user_participants do |t|
      t.integer :user_id  
      t.integer :participant_id 
    end
  end
end
