class AddDeliveryFromCounterpartiesToProductEntries < ActiveRecord::Migration[7.0]
  def change
    change_column :product_entries, :delivery_from_counterparty_id, :bigint, null: true
  end
end
