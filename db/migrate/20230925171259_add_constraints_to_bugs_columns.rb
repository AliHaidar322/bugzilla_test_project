class AddConstraintsToBugsColumns < ActiveRecord::Migration[7.0]
  def change
    change_column :bugs, :title, :string, null: false
    change_column :bugs, :status, :integer, null: false, default: 0
    change_column :bugs, :bug_type, :string, null: false
    change_column :bugs, :deadline, :date, null: false
  end
end
