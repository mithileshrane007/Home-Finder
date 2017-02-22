class ChangeCoulmnMessage < ActiveRecord::Migration
  def change
  	change_column :messages, :created_date, :datetime
  end
end
