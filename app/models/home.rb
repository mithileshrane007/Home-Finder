class Home < ActiveRecord::Base
	has_many :home_images
	has_many :messages
	belongs_to :user
	geocoded_by :address,
	  :latitude => :lat, :longitude => :lng
	after_validation :geocode
end
