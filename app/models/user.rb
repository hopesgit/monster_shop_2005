class User < ApplicationRecord
  has_many :orders 

  validates_presence_of :name
  validates_presence_of :street_address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip
  validates :email_address, uniqueness: true, presence: true
  validates_presence_of :password, require: true
  enum role: %w(default merchant admin)
  has_secure_password
end
