# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  has_many :games
  validates :username, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true
end
