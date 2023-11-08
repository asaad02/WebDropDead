# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  has_many :games

  before_create :set_default_values

  private

  def set_default_values
    self.quarters ||= 3
    self.dice ||= 3
    self.points ||= 0
  end
end
