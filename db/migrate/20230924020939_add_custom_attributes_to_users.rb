class AddCustomAttributesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :user_type, :integer, null: false
  end
end
