class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
  	  t.string :email
  	  t.string :mobile_number
      t.string :password_digest
  	  t.string :token
  	  t.string :password_reset_token
  	  t.string :email_verify_token
      t.boolean :email_verified , default: false
      t.boolean :blocked , default: false
      t.boolean :successfully_terminated , default: true
      t.timestamps
    end
  end
end
