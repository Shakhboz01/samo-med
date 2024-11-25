class AddBonusUserRefToSales < ActiveRecord::Migration[7.0]
  def change
    add_reference :sales, :bonus_user, null: true, foreign_key: true
  end
end
