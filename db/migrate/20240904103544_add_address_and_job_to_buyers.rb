class AddAddressAndJobToBuyers < ActiveRecord::Migration[7.0]
  def change
    add_column :buyers, :job, :string
    add_column :buyers, :address, :string
  end
end
