class CreateSanctionedLibrariesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :sanctioned_libraries do |t|
      t.string :name
      t.timestamp
    end
  end
end