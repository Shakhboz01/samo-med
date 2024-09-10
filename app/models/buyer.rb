class Buyer < ApplicationRecord
  include ProtectDestroyable

  attr_accessor :debt_in_usd
  attr_accessor :debt_in_uzs

  enum gender: %i[erkak ayol]
  validates_presence_of :name
  validates_uniqueness_of :phone_number, message: "Mijoz avval ro'yxatdan o'tgan!"
  validates :phone_number, length: { is: 9 }
  has_one_attached :image
  has_many :sales
  has_many :treatments
  has_many :room_members
  has_many :sale_from_local_services
  has_many :sale_from_services
  before_update :send_message
  after_create :send_create_message
  scope :active, -> { where(:active => true) }

  def calculate_debt_in_usd
    self.sales.price_in_usd.sum(:total_price) - self.sales.price_in_usd.sum(:total_paid)
  end

  def has_todays_treatment
    last_treatment = treatments.order(created_at: :asc).last
    return nil if last_treatment.nil?
    return nil if last_treatment.created_at < DateTime.current.beginning_of_day

    last_treatment
  end

  def calculate_debt_in_uzs
    self.sales.price_in_uzs.sum(:total_price) - self.sales.price_in_uzs.sum(:total_paid)
  end

  def name_with_phone
    "#{name} | #{phone_number}"
  end

  private

  def send_create_message
    message =
      "YANGI BEMOR!\n" \
      "<a href=\"https://#{ENV.fetch('HOST_URL')}/buyers/#{id}\">#{name}</a>\n"
    message << "#{comment}\n" if comment
    message << phone_number if phone_number
    SendMessageJob.perform_later(message)
  end

  def send_message
    return
    message =
      "<a href=\"https://#{ENV.fetch('HOST_URL')}/buyers/#{id}\">#{name} vrach ko'rigiga yuborildi</a>\n"
    message << comment if comment
    SendMessageJob.perform_later(message)
  end
end
