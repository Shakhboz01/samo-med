class Buyer < ApplicationRecord
  include ProtectDestroyable

  attr_accessor :debt_in_usd
  attr_accessor :debt_in_uzs

  validates_presence_of :name
  validates_uniqueness_of :phone_number, message: "Mijoz avval ro'yxatdan o'tgan!"
  validates :phone_number, length: { is: 9 }
  has_one_attached :image
  has_many :sales
  has_many :treatments
  has_many :sale_from_local_services
  has_many :sale_from_services
  scope :active, -> { where(:active => true) }

  def calculate_debt_in_usd
    self.sales.price_in_usd.sum(:total_price) - self.sales.price_in_usd.sum(:total_paid)
  end

  def calculate_debt_in_uzs
    self.sales.price_in_uzs.sum(:total_price) - self.sales.price_in_uzs.sum(:total_paid)
  end
end
