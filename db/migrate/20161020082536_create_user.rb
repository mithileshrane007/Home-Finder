class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username 
      t.string :email 
      t.string :first_name 
      t.string :last_name 
      t.date :created_date
      t.boolean :is_admin
      t.string :password_digest
    end
  end
end
