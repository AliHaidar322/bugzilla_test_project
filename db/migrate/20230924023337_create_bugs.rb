class CreateBugs < ActiveRecord::Migration[7.0]
  def change
    create_table :bugs do |t|
      t.string :title, null: false
      t.string :description
      t.string :bug_type, null: false
      t.integer :status, null: false, default: 0 
      t.date :deadline, null: false
      t.references :assign_to, foreign_key: { to_table: :users }
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
