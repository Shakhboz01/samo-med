class ChangePriceInUsd < ActiveRecord::Migration[7.0]
  def change
    change_column :packs, :price_in_usd, :boolean, default: false
    change_column :delivery_from_counterparties, :price_in_usd, :boolean, default: false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
