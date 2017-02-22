class AddPaperclipToHomeImage < ActiveRecord::Migration
  def change
  	add_attachment :home_images, :photo
  end
end
