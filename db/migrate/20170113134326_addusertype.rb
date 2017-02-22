class Addusertype < ActiveRecord::Migration
  def change
  	add_column :users, :is_realtor, :boolean
  end
end
