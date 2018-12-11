class CreateReposTable < ActiveRecord::Migration[5.2]
  def change
    create_table :repos do |t|
      t.integer :gitlab_id
      t.string  :name, null: false
      t.string  :type
      t.string  :gitlab_url, null: false
      t.index [:gitlab_id], unique: true
      t.index [:name], unique: true
      t.index [:type]
    end
  end
end