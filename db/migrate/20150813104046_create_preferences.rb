class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences, id: false do |t|
      t.string :name, limit: 50, null: false
      t.string :value, limit: 200, null: false
      t.timestamps null: false
    end
  end
end
