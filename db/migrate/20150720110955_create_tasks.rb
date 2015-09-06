class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :uuid, limit: 36, null: false
      t.references :demander, null: false
      t.references :supplier
      t.string :content, limit: 8000, null: false
      t.references :category
      t.references :region
      t.string :consignee_name, limit: 50, null: false
      t.string :consignee_phone, limit: 20, null: false
      t.string :consignee_address, limit: 1200, null: false
      t.string :consignee_postal_code, limit: 10
      t.integer :quantity, limit: 1, null: false
      t.decimal :estimate_unit_price, precision: 8, scale: 2
      t.decimal :estimate_total_price, precision: 8, scale: 2
      t.decimal :actual_unit_price, precision: 8, scale: 2
      t.decimal :actual_total_price, precision: 8, scale: 2
      t.decimal :deposit, precision: 8, scale: 2
      t.boolean :deposit_paid, null: false
      t.decimal :balance, precision: 8, scale: 2
      t.decimal :commission, precision: 8, scale: 2
      t.boolean :final_paid, null: false
      t.datetime :published_at
      t.datetime :accepted_at
      t.datetime :purchased_at
      t.datetime :cleared_at
      t.datetime :finished_at
      t.datetime :cancelled_at
      t.datetime :trashed_at
      t.string :reason_of_cancellation_cd, limit: 20
      t.string :state, limit: 20, null: false
      t.timestamps null: false
    end
  end
end