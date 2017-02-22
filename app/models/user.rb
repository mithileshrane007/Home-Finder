class User < ActiveRecord::Base
	has_many :homes
	has_one :user, foreign_key: 'from_user_id'
	has_one :user, foreign_key: 'to_user_id'
	has_secure_password
	has_attached_file :photo, styles: { :large=>"500
		*800" ,:medium=> "200*250" , :small=>"100*150"}
	do_not_validate_attachment_file_type :photo
end
