class AddFIeldToSale < ActiveRecord::Migration[7.0]
  def change
    add_column :sales, :total_worker_price, :decimal, precision: 10, scale: 2
  end
end
