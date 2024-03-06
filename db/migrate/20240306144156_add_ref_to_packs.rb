class AddRefToPacks < ActiveRecord::Migration[7.0]
  def change
    add_reference :packs, :product_category, null: true, foreign_key: true
  end
end
