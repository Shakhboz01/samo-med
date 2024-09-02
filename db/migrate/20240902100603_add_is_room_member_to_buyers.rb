class AddIsRoomMemberToBuyers < ActiveRecord::Migration[7.0]
  def change
    add_column :buyers, :is_room_member, :boolean, default: false
  end
end
