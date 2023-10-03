class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false, unique: true
      t.text :description, null: false

      t.timestamps
    end

    add_index :projects, :name, unique: true
  end
end
