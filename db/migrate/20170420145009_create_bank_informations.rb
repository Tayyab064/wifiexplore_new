class CreateBankInformations < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_informations do |t|
		t.string :currency
    	t.string :country
    	t.string :name
    	t.string :routing_number
    	t.string :account_number
    	t.integer :lender_id
      	t.timestamps
    end
  end
end
