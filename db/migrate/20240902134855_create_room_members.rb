class CreateRoomMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :room_members do |t|
      t.boolean :active_member, default: true
      t.string :comment
      t.references :buyer, null: false, foreign_key: true
      t.datetime :end_time, default: nil
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
