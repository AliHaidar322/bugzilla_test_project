class AddAssignToReferenceToBugs < ActiveRecord::Migration[7.0]
  def change
    add_reference :bugs, :assign_to, foreign_key: { to_table: :users }
  end
end
