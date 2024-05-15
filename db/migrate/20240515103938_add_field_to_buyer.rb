class AddFieldToBuyer < ActiveRecord::Migration[7.0]
  def change
    add_column :buyers, :is_worker, :boolean, default: false
  end
end
