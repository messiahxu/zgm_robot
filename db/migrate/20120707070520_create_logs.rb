class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :log

      t.timestamps
    end
  end
end
