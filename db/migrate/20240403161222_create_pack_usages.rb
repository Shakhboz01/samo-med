class CreatePackUsages < ActiveRecord::Migration[7.0]
  def change
    create_table :pack_usages do |t|
      t.references :pack, null: false, foreign_key: true
      t.integer :list_of_pack_id
      t.decimal :amount, precision: 15, scale: 2

      t.timestamps
    end
  end
end
