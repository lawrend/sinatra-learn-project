class UserParticipant < ActiveRecord::Base
  belongs_to :user  
  belongs_to :participant  
end
