class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uuid, limit: 36, null: false
      t.string :open_id, limit: 28, null: false
      t.string :phone, limit: 11
      t.string :nickname, limit: 50
      t.string :portrait, limit: 40
      t.string :state, limit: 20, null: false
      t.timestamps null: false
    end
  end
end