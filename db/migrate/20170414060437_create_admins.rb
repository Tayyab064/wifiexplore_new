class CreateAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :admins do |t|
      t.string :email
      t.string :password_digest
      t.string :password_reset_token
      t.timestamps
    end
  end
end
