class Sale < ApplicationRecord
  attr_accessor :discount_price
  belongs_to :buyer
  belongs_to :user
  enum status: %i[processing closed]
  enum payment_type: %i[наличные карта click предоплата перечисление дригие]
  has_many :product_sells
  has_many :total_profit, through: :product_sells
  has_one :discount
  has_many :transaction_histories, dependent: :destroy
  scope :unpaid, -> { where("total_price > total_paid") }
  scope :price_in_uzs, -> { where('price_in_usd = ?', false) }
  scope :price_in_usd, -> { where('price_in_usd = ?', true) }
  scope :filter_by_total_paid_less_than_price, ->(value) {
          if value == "1"
            where("total_paid < total_price")
          else
            all
          end
        }
  before_create :send_message
  before_update :update_product_sales_currencies
  after_save :process_status_change, if: :saved_change_to_status?

  def calculate_total_price(enable_to_alter = true)
    total_price = 0
    self.product_sells.each do |product_sell|
      total_price += product_sell.amount * product_sell.sell_price
    end

    if enable_to_alter
      self.total_price = total_price unless closed?
    end

    total_price
  end

  def total_profit
    product_sells.sum(:total_profit)
  end

  def sells_info
    product_sells.map {|ps| "#{Translit.convert(ps.pack.name, :english).gsub(/[^0-9a-zA-Z]/, ' ')} - #{ps.total_price}"}.join(', ')
  end

  private

  def send_message
    message =
      "YANGI BEMOR!\n" \
      "<a href=\"https://#{ENV.fetch('HOST_URL')}/buyers/#{buyer_id}\">#{buyer.name}</a>\n"
    message << buyer.comment if buyer.comment
    SendMessageJob.perform_later(message)
  end

  def process_status_change
    if closed? && status_before_last_save != 'closed'
      if enable_to_send_sms
        price_sign = price_in_usd ? '$' : 'сум'
        message =  "<b>Xizmat amalga oshirildi</b>\n" \
          "<b>Bemor</b>: #{buyer.name.capitalize}\n"

        message << "<b>Комментарие:</b> #{comment}\n" if comment.present?
        product_sells.each do |ps|
          message << "#{ps.pack.name} - #{ps.sell_price} * #{ps.amount} = #{ps.total_price}\n"
        end

        message << "<b>Jami narx:</b> #{total_price} #{price_sign}\n"
        SendMessageJob.perform_later(message)
      else
        self.enable_to_send_sms = false
      end
    end
  end

  def update_product_sales_currencies
    return if product_sells.empty? || !price_in_usd_changed?

    product_sells.each do |ps|
      ps.price_in_usd = price_in_usd
      ps.save!
    end

    self.total_price = product_sells.sum(('sell_price * amount'))
  end
end
