class CreateRobots < ActiveRecord::Migration
  def change
    create_table :robots do |t|
      t.string :receive
      t.text :reply
      t.string :username

      t.timestamps
    end
  end
end
