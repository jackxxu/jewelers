class CreateUsesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :uses do |t|
      t.integer :repo_id
      t.integer :library_id
      t.index [:repo_id]
      t.index [:library_id]
    end
  end
end