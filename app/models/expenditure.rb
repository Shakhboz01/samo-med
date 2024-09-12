class Expenditure < ApplicationRecord
  include ProtectEditAfterDay
  include ProtectDestroyAfterDay
  include SendImage
  attr_accessor :rate
  attr_accessor :image

  belongs_to :user
  belongs_to :combination_of_local_product, optional: true
  belongs_to :delivery_from_counterparty, optional: true
  has_many :transaction_histories, dependent: :destroy
  validates_presence_of :expenditure_type
  validates_presence_of :price
  enum expenditure_type: %i[bank boshqa_xarajatlar yol_kira qarz]
  enum payment_type: %i[naqt карта click boshqa]
  scope :price_in_uzs, -> { where('price_in_usd = ?', false) }
  scope :price_in_usd, -> { where('price_in_usd = ?', true) }

  validate :check_if_total_paid_is_not_more_than_price
  after_create :set_transaction_history_and_notify_via_tg
  before_save :set_total_paid
  before_destroy :varify_delivery_from_counterparty_is_not_closed
  scope :unpaid, -> { where("price > total_paid") }
  scope :filter_by_total_paid_less_than_price, ->(value) {
          if value == "1" # The checkbox value when selected
            where("total_paid < price")
          else
            all # No filter when the checkbox is not selected
          end
        }
  before_destroy :send_destroy_message

  private

  def set_transaction_history_and_notify_via_tg
    self.transaction_histories.create(price: total_paid, first_record: true, user_id: user.id)
    message =
      "<b>#{user.name} tomonidan rasxod qilindi</b>\n" \
      "<b>Turi:</b> #{expenditure_type}\n" \
      "<b>To'lov turi:</b> #{payment_type}\n" \
      "<b>Jami summa:</b> #{price} #{price_in_usd ? '$' : 'сум'}\n"

    message << "<b>Комментарие:</b> #{comment}" if comment.present?
    SendMessageJob.perform_later(message)
  end

  def send_destroy_message
    message =
      "#{ user.name} tomonidan xarajat tizimdan o\'chirildi!\n" \
      "Narx: #{price}\n" \
      "Sana: #{created_at}\n"
    SendMessageJob.perform_later(message)
  end

  def check_if_total_paid_is_not_more_than_price
    return if total_paid.nil?

    errors.add(:base, "cannot be greater than price") if total_paid > price
  end

  def set_total_paid
    return unless total_paid.nil?

    self.total_paid = price.to_f
  end

  def varify_delivery_from_counterparty_is_not_closed
    throw(:abort) if !delivery_from_counterparty.nil? && delivery_from_counterparty.closed?
    throw(:abort) if !combination_of_local_product.nil? && combination_of_local_product.closed?
  end
end
