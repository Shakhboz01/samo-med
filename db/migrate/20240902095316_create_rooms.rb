class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :capacity
      t.integer :active_members, default: 0

      t.timestamps
    end
  end
end
