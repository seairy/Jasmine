class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :uuid, limit: 36, null: false
      t.references :demander, null: false
      t.references :supplier
      t.string :content, limit: 8000, null: false
      t.references :region
      t.decimal :estimate_price, precision: 8, scale: 2
      t.decimal :actual_price, precision: 8, scale: 2
      t.decimal :deposit, precision: 8, scale: 2
      t.boolean :deposit_paid, null: false
      t.decimal :balance, precision: 8, scale: 2
      t.decimal :commission, precision: 8, scale: 2
      t.boolean :final_paid, null: false
      t.string :state, limit: 20, null: false
      t.timestamps null: false
    end
  end
end