class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.float :amount
      t.references :user
      t.timestamps
    end
  end
end
