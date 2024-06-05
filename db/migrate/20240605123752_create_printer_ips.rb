class CreatePrinterIps < ActiveRecord::Migration[7.0]
  def change
    create_table :printer_ips do |t|
      t.string :ip

      t.timestamps
    end
  end
end
