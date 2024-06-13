class AddIsMaleToBuyers < ActiveRecord::Migration[7.0]
  def change
    add_column :buyers, :gender, :integer, default: 0
  end
end
