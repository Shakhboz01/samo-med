class AddContextToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :context, :string
  end
end
