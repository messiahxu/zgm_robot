class Admin < ActiveRecord::Base
  has_secure_password
  attr_accessible :password, :username
end
