class AddHomeIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :home_id, :integer
  end
end
