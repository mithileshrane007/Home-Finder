# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# User.create(username: 'farman_a',email: 'farman@infiny.in',first_name: 'farman',last_name: 'ali',created_date: DateTime.now.to_date,password_digest: BCrypt::Password.create('aaaaaa'))  
# User.create(username: 'sushil_p',email: 'sushil@infiny.in',first_name: 'sushil',last_name: 'pawar',created_date: DateTime.now.to_date,password_digest: BCrypt::Password.create('aaaaaa'))  
User.create(username: 'admin',email: 'kuldeep.j@infiny.in',created_date: DateTime.now.to_date,password_digest: BCrypt::Password.create('admin'),is_)  