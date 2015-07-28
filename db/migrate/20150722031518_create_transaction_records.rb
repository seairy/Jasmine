class CreateTransactionRecords < ActiveRecord::Migration
  def change
    create_table :transaction_records do |t|
      t.string :serial_number, limit: 32, null: false
      t.references :user, null: false
      t.string :type_cd, limit: 20, null: false
      t.decimal :amount, precision: 9, scale: 2
      t.timestamps null: false
    end
  end
end
