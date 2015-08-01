class CreateTaskOperations < ActiveRecord::Migration
  def change
    create_table :task_operations do |t|
      t.references :task, null: false
      t.references :user, null: false
      t.string :content_cd, limit: 20, null: false
      t.timestamps null: false
    end
  end
end
