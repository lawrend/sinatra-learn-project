class Activity < ActiveRecord::Base
  validates_presence_of :name, :message => "gotta be something"
  has_many :activity_events
  has_many :events, through: :activity_events
  has_many :participants, through: :events
  has_many :users, through: :events
end
