class Event < ActiveRecord::Base
  validates_presence_of :name
  has_many :activity_events
  has_many :activities, through: :activity_events
  has_one :participant
  has_many :users, through: :participant
  belongs_to :user

end
