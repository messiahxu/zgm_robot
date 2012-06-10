class CreateWikis < ActiveRecord::Migration
  def change
    create_table :wikis do |t|
      t.string :receive
      t.text :reply

      t.timestamps
    end
    add_index :wikis, :receive, :unique=>true
  end
end
