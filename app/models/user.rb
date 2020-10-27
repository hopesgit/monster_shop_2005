class User < ApplicationRecord

  validates_presence_of :name
  validates_presence_of :street_address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip
  validates :email_address, uniqueness: true, presence: true
  validates_presence_of :password, require: true
  has_secure_password 
end
