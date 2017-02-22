class Changecoldatetype < ActiveRecord::Migration
  def change
  	change_column :homes, :open_house_start_time,  :datetime
  	change_column :homes, :open_house_end_time,  :datetime
  end
end
