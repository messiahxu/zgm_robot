class AddStatusToRobots < ActiveRecord::Migration
  def change
    add_column :robots, :status, :integer, :default=>0
    Robot.all.each do |r|
      r.status = 0
    end

  end

end
