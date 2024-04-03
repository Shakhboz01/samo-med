class PackUsage < ApplicationRecord
  belongs_to :pack
  validate :category_has_weight_of_one

  private

  def category_has_weight_of_one
    return if pack.product_category.weight == 1

    errors.add(:base, 'Weight is not equal to 1')
  end
end
