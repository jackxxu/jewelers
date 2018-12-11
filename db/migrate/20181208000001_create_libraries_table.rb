class CreateLibrariesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :libraries do |t|
      t.string   :name, null: false
      t.string   :github_url
      t.string   :description
      t.string   :authors
      t.integer  :code_size
      t.integer  :star_count
      t.integer  :watcher_count
      t.string   :license
      t.integer  :downloads
      t.boolean  :sanctioned
      t.datetime :last_commit_dt
      t.index [:name], unique: true
      t.index [:sanctioned]
    end
  end
end