class User < ActiveRecord::Base
  validates_presence_of :username, :email, :password
  has_secure_password
  has_many :user_participants
  has_many :participants, through: :user_participants
  has_many :events
  has_many :activities, through: :participants
end

