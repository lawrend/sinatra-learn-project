class User < ActiveRecord::Base
  validates_presence_of :username, :email, :password, :message => "gotta fill it in!"
  has_secure_password
  has_many :user_participants
  has_many :participants, through: :user_participants
  has_many :events
  has_many :activities, through: :participants
  extend Slugifiable
  include Slugifiable
end

