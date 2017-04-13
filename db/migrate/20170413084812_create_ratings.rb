class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :ratings do |t|
      t.integer :rate , default: 1
      t.references :connection
      t.timestamps
    end
  end
end
