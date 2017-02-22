class HomeImage < ActiveRecord::Base
	belongs_to :home
	has_attached_file :photo, styles: { :large=>"500
		*800" ,:medium=> "250*200" , :small=>"50*70"}
    do_not_validate_attachment_file_type :photo
end
