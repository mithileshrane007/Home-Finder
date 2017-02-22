class CreateHomeImage < ActiveRecord::Migration
  def change
    create_table :home_images do |t|
    	t.integer :home_id, :null => false, :references => [:home_id, :id]
  		t.string :photo
    end
  end
end
