class UserMailer < ApplicationMailer
	def forgot_email(user,password)
    	@user = user
    	@password=password
    
    	mail(to: @user.email, subject: 'reset password')
  	end
end
