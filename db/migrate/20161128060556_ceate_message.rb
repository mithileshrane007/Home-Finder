class CeateMessage < ActiveRecord::Migration
  def change
  	create_table :messages do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.string :message 
      t.date :created_date
    end
  end
end
