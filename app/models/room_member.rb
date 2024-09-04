class RoomMember < ApplicationRecord
  belongs_to :buyer
  belongs_to :room

  before_create :update_data
  before_update :set_end_time

  private

  def update_data
    buyer.update(is_room_member: true)
    message =
      "<b>Bemor palataga olindi:</b>\n" \
      "Palata: #{room.name}\n" \
      "Bemor: #{buyer.name}\n"
    SendMessageJob.perform_later(message)
    room.increment!(:active_members, 1)
  end

  def set_end_time
    return if end_time != end_time_was

    room.decrement!(:active_members, 1)
    buyer.update(is_room_member: false)
    total_income = buyer.sales.where('created_at > ?', created_at).sum(:total_price)
    message =
      "<b>Bemor palatadan olindi:</b>\n" \
      "Palata: #{room.name}\n" \
      "Bemor: #{buyer.name}\n" \
      "Kelgan sana: #{created_at}\n"
      "Jami pul tushumi: #{total_income} so'm\n"

    SendMessageJob.perform_later(message)
  end
end
