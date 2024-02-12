class AddColumnToPacks < ActiveRecord::Migration[7.0]
  def change
    add_column :packs, :active, :boolean, default: true
  end
end
