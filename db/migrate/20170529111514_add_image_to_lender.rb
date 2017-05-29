class AddImageToLender < ActiveRecord::Migration[5.0]
  def change
  	add_column :lenders , :image , :string
  end
end
