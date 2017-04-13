class CreateLenders < ActiveRecord::Migration[5.0]
  def change
    create_table :lenders do |t|
      t.string :name
  	  t.string :email
  	  t.string :mobile_number
      t.string :password_digest
  	  t.string :token
  	  t.string :password_reset_token
  	  t.string :email_verify_token
  	  t.string :mobile_verify_token
      t.boolean :email_verified , default: false
      t.boolean :mobile_number_verified , default: false
      t.boolean :blocked , default: false
      t.timestamps
    end
  end
end
