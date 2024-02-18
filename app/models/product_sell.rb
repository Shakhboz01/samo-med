# product combination usage
# if price_data has a key of `0`, it means from product model, not from prod entry
# increase product initial remaining before_destroy if price data contains 0
class ProductSell < ApplicationRecord
  attr_accessor :pack_name
  attr_accessor :initial_remaining
  attr_accessor :remaining_outside_pack
  attr_accessor :barcode
  attr_accessor :rate
  attr_accessor :min_price_in_usd

  belongs_to :sale
  belongs_to :pack
  belongs_to :product, optional: true
  has_one :buyer, through: :sale
  has_one :user, through: :sale
  validates_presence_of :amount
  enum payment_type: %i[наличные карта click предоплата перечисление дригие]
  scope :price_in_uzs, -> { where('price_in_usd = ?', false) }
  scope :price_in_usd, -> { where('price_in_usd = ?', true) }
  before_create :set_prices_and_profit
  before_create :increase_amount_sold # TASK 1
  before_update :set_prices_and_profit
  after_create :increase_total_price_and_send_notify
  before_destroy :decrease_amount_sold # TASK 2
  before_destroy :decrease_total_price

  scope :price_in_uzs, -> { where('price_in_usd = ?', false) }
  scope :price_in_usd, -> { where('price_in_usd = ?', true) }

  private

  def increase_total_price_and_send_notify
    if !sale.nil?
      sale.increment!(:total_price, (sell_price * amount))
    end

    SendMessage.run(message: "#{pack.name} - #{pack.initial_remaining}", chat: 'report')
  end

  def decrease_total_price
    sale.decrement!(:total_price, (sell_price * amount))
  end

  def decrease_amount_sold
    return throw(:abort) if !sale.nil? && sale.closed?

    pack.increment!(:initial_remaining, amount)
  end

  def increase_amount_sold
    pack.decrement!(:initial_remaining, amount)
  end

  def set_prices_and_profit
    self.buy_price = pack.buy_price
    profit = sell_price - buy_price
    self.total_profit = profit * amount
  end
end
