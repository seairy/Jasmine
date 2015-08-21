class CreateConsignees < ActiveRecord::Migration
  def change
    create_table :consignees do |t|
      t.references :user, null: false
      t.string :name, limit: 50, null: false
      t.string :phone, limit: 20, null: false
      t.string :address, limit: 1200, null: false
      t.string :postal_code, limit: 10
      t.boolean :primary, default: false, null: false
      t.timestamps null: false
    end
  end
end
