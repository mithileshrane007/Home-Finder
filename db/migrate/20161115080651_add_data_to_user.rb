class AddDataToUser < ActiveRecord::Migration
  def change
  	add_column :users, :phone_number, :string
  	add_column :users, :company, :string
  end
end
