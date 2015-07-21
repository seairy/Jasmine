class CreateVerificationCodes < ActiveRecord::Migration
  def change
    create_table :verification_codes do |t|
      t.references :user, null: false
      t.string :type_cd, limit: 50, null: false
      t.string :phone, limit: 11, null: false
      t.string :content, limit: 6, null: false
      t.boolean :available, default: true, null: false
      t.datetime :expired_at, null: false
      t.timestamps null: false
    end
  end
end
