class CreateBehaviors < ActiveRecord::Migration
  def change
    create_table :behaviors do |t|
      t.references :user, null: false
      t.string :content_cd, limit: 50, null: false
      t.string :user_agent, limit: 200
      t.timestamps null: false
    end
  end
end
