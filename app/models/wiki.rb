class Wiki < ActiveRecord::Base
   attr_accessible :receive, :reply
   validates :receive, :uniqueness => true
end
