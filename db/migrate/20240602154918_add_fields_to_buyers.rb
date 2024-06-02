class AddFieldsToBuyers < ActiveRecord::Migration[7.0]
  def change
    add_column :buyers, :jshr, :string
    add_column :buyers, :birthday, :date
  end
end
