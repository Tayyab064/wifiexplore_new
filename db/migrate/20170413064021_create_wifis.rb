class CreateWifis < ActiveRecord::Migration[5.0]
  def change
    create_table :wifis do |t|
      t.float :latitude
      t.float :longitude
      t.string :address
      t.string :name
      t.string :password
      t.string :ssid
      t.string :security_type
      t.float :price , default: 0.0
      t.integer :avg_speed
      t.boolean :blocked , default: false
      t.references :lender
      t.timestamps
    end
  end
end
