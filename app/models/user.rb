class User < ActiveRecord::Base
  acts_as_authentic
  
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_presence_of :email
  validates_format_of :email,
   :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
   :message => "Invalid email address format"
  validates_presence_of :crypted_password
  validates_presence_of :password_salt
  validates_presence_of :persistence_token
end
