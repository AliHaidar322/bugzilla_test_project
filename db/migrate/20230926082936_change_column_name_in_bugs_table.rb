class ChangeColumnNameInBugsTable < ActiveRecord::Migration[7.0]
  def change
    rename_column :bugs, :user_id, :creator_id
  end
end
