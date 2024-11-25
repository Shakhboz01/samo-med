class CreateBonusUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :bonus_users do |t|
      t.string :name

      t.timestamps
    end
  end
end
