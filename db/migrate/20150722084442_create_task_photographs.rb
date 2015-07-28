class CreateTaskPhotographs < ActiveRecord::Migration
  def change
    create_table :task_photographs do |t|
      t.references :task, null: false
      t.string :file, null: false
      t.integer :position, null: false
      t.timestamps null: false
    end
  end
end