class AddConstraintsToProjectsColumns < ActiveRecord::Migration[7.0]
  def change
    change_column :projects, :name, :string, null: false
    change_column :projects, :description, :string, null: false
  end
end
