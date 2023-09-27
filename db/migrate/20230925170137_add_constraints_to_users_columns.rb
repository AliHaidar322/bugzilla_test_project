class AddConstraintsToUsersColumns < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :name, :string, null: false
    change_column :users, :user_type, :integer, null: false
  end
end
