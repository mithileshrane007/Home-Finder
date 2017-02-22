class CreateHome < ActiveRecord::Migration
  def change
    create_table :homes do |t|
    	t.string :home_type 
    	t.string :address
    	t.string :description
    	t.date :open_house_date
    	t.time :open_house_start_time
    	t.time :open_house_end_time
    	t.boolean :for_sale
    	t.integer :beds
    	t.integer :baths
    	t.string :price
    	t.decimal :lat
    	t.decimal :lng
    end
  end
end
