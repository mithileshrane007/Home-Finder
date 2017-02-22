class UserController < ApplicationController
	def login_window
		if session[:user_id]
			@current_user = User.find(session["user_id"])
		    if @current_user.is_admin
		    	redirect_to '/user/index'
		    else
	      		flash[:notice]= 'Access Denied'
		    end
		end
	end

	def login
		user = User.find_by_username(params[:username])
	    if user && user.authenticate(params[:password])
	      session[:user_id] = user.id
	      @current_user = User.find(session["user_id"])
	      if @current_user.is_admin
	      	redirect_to '/user/index'
	      else
	      	flash[:notice]= 'Access Denied'
	      	redirect_to '/'
	      end
	    else
	    	if not user  
	      		flash[:notice]= 'Invalid Username'
	      	else
	      		flash[:notice]= 'Invalid Password'
	      	end
	      	redirect_to '/'
	    end
	end

	def destroy
  		session[:user_id] = nil
  		redirect_to root_path
  	end

  	def forgot_password
  		if request.post?
  			user = User.find_by_email(params[:email])
  			if not user.blank?
  				o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
		     	string = (0..5).map { o[rand(o.length)] }.join
		     	UserMailer.forgot_email(user,string).deliver_now
  				user.password_digest = BCrypt::Password.create(string)
  				user.save
  				flash[:msg]= 'Please check your email for new password'
  				redirect_to '/'
  			else
  				flash[:notice]= 'Invalid email address'
  			end
  		end
  	end

  	def change_password
  		if request.post?
  			user = User.find_by_is_admin(true)
			user.password_digest = BCrypt::Password.create(params[:new_password])
			user.save
  			session[:user_id] = nil
  			flash[:msg]= 'Password changed successfully'
  			redirect_to '/'
  		end
  	end

  	def check_password
	  
	    user = User.find_by_is_admin(true)

	    if user && user.authenticate(params[:old_password])
	        render :json => true
	    else      
	        render :json => false
	    end
	        
	end

	def index
		
		if session[:user_id]
	    	@current_user = User.find(session["user_id"])
	    	if @current_user.is_admin
				@users = User.where(is_admin: nil)
	    	else
	    		redirect_to "/"
	    	end
	    else
			redirect_to "/"
  		end
	end

	def edit
		if session[:user_id]
	    	@current_user = User.find(session["user_id"])
	    	if @current_user.is_admin
	    		
				@user = User.find(params[:user_id])
				if request.post?
					@user.username = params[:username]
					@user.email = params[:email]
					@user.name = params[:name]
				 	@user.save
					flash[:msg] = "Success! Changes saved Successfully"
					redirect_to "/user/index/"
				end
	    	else
	    		redirect_to "/"
	    	end
	    else
			redirect_to "/"
  		end
		
	end

        def delete

                if session[:user_id]
                @current_user = User.find(session["user_id"])
                if @current_user.is_admin
                                user = User.find(params[:user_id])
                                user.destroy
                                flash[:msg] = "Success! User deleted succefully"
                                redirect_to "/user/index/" 
                else
                        redirect_to "/"
                end
            else
                        redirect_to "/"
                end
        end

	def validate_username_old
		if User.find(params[:user_id]).username == params[:username]
			render :json => true
		else
			begin
				User.find_by_username(params[:username]).id
				render :json => false
			rescue Exception => e
				render :json => true
			end
		end
	end

end
