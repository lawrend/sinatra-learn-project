class Participant <ActiveRecord::Base
  has_many :user_participants
  has_many :users, through: :user_participants
  belongs_to :event
  has_many :activities, through: :event
end
