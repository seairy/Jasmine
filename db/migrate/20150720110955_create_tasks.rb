class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :user, null: false
      t.string :content, limit: 8000, null: false
      t.datetime :published_at, null: false
      t.string :state, limit: 20, null: false
      t.timestamps null: false
    end
  end
end
