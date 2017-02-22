class AddData1ToUser < ActiveRecord::Migration
  def change
  	add_column :users, :is_guest, :boolean
  	add_column :users, :is_host, :boolean
  	add_column :homes, :user_id, :integer
  end
end
