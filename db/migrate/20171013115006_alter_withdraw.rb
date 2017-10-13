class AlterWithdraw < ActiveRecord::Migration[5.0]
  def change
  	add_column :withdraws , :name , :string
  	add_column :withdraws , :email , :string
  	add_column :withdraws , :paypalemail , :string
  end
end
