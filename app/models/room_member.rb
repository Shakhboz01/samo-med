class RoomMember < ApplicationRecord
  belongs_to :buyer
  belongs_to :room

  before_create :update_data
  before_update :set_end_time


  def calculate_total_sale_price
    sales = buyer.sales.where('created_at >= ?', created_at)
    sales = sales.where('created_at <= ?', end_time) unless end_time.nil?
    sales.sum(:total_price)
  end

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
    return if active_member == active_member_was

    self.end_time = DateTime.current
    room.decrement!(:active_members, 1)
    buyer.update(is_room_member: false)
    message =
      "<b>Bemor palatadan olindi:</b>\n" \
      "Palata: #{room.name}\n" \
      "Bemor: #{buyer.name}\n" \
      "Kelgan sana: #{created_at}\n" \
      "Jami pul tushumi: #{calculate_total_sale_price} so'm\n"

    SendMessageJob.perform_later(message)
  end
end
