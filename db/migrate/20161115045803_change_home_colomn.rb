class ChangeHomeColomn < ActiveRecord::Migration
  def change
  	change_column :homes, :lat, :decimal, precision: 10, scale: 6
  	change_column :homes, :lng, :decimal, precision: 10, scale: 6
  end
end
