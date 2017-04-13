class CreateConnections < ActiveRecord::Migration[5.0]
  def change
    create_table :connections do |t|
		t.datetime :disconnected_at
		t.float :download_data , default: 0.0
		t.float :upload_data , default: 0.0
		t.datetime :connected_at
		t.float :total_bill , default: 0.0
		t.references :wifi
		t.references :user
      	t.timestamps
    end
  end
end
