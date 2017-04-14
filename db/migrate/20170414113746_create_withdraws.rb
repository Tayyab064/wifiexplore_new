class CreateWithdraws < ActiveRecord::Migration[5.0]
  def change
    create_table :withdraws do |t|
	  t.float :amount , default: 0.0
	  t.boolean :transfered , default: false
	  t.references :lender
      t.timestamps
    end
  end
end
