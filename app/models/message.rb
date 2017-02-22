class Message < ActiveRecord::Base
	belongs_to :home
	belongs_to :from_user, class_name: 'Message'
	belongs_to :to_user, class_name: 'Message'
end