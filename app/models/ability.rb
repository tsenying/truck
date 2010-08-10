# http://github.com/ryanb/cancan
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # in case not signed in
    if user.admin?
      can :manage, :all
    else
      can :read, :all
      
      # contributors can create Vendors
      if user.is? :contributor
        can :create, Vendor
      end
      
      # anyone can register
      can :create, User
      
      # user can update own profile
      can :update, User do |u|
        u == user
      end
    end
  end
end
