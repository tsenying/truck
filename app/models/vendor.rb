class Vendor < ActiveRecord::Base
  has_many :locations, :dependent => :destroy
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_numericality_of :following, :allow_nil => true
  validates_numericality_of :followers, :allow_nil => true
  validates_numericality_of :listed, :allow_nil => true
  validates_numericality_of :tweets, :allow_nil => true
end
