class User < ActiveRecord::Base
  acts_as_authentic
  
  validates_presence_of :username
  validates_uniqueness_of :username
  # validates_presence_of :email
  # validates_format_of :email,
  #  :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
  #  :message => "Invalid email address format"
  # validates_presence_of :crypted_password
  # validates_presence_of :password_salt
  # validates_presence_of :persistence_token
  
  # http://wiki.github.com/ryanb/cancan/role-based-authorization
  # new roles must be added at the end of this array
  ROLES = %w[admin contributor banned]
  
  # roles = array of elements from ROLES
  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end
  
  def is?(role)
    roles.include?(role.to_s)
  end
  
  def admin?
    is? :admin
  end
end
