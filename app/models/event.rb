class Event < ActiveRecord::Base
  validates_presence_of :name, :message => "needs to be filled in"
  has_many :activity_events
  has_many :activities, through: :activity_events
  has_many :participants
  has_many :users, through: :participants
  belongs_to :user
  extend Slugifiable
  include Slugifiable

end
