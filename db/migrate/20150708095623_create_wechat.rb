class CreateWechat < ActiveRecord::Migration
  def change
    create_table :wechat, id: false do |t|
      t.string :access_token, limit: 512, null: false
      t.datetime :expired_at, null: false
    end
  end
end
