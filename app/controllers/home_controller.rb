class HomeController < ApplicationController
	def index
		if session[:user_id]
	    	@current_user = User.find(session["user_id"])
	    	if @current_user.is_admin
				@homes = Home.all
	    	else
	    		redirect_to "/"
	    	end
	    else
			redirect_to "/"
  		end
	end

	def show
		if session[:user_id]
	    	@current_user = User.find(session["user_id"])
	    	if @current_user.is_admin
				@home = Home.find(params[:home_id])
				@home_images =[]
				data = HomeImage.where(home_id: @home.id)
				
				x=1
				for i in data
					data1 = {}
					data1['photo'] = i.photo(:medium)
					data1['big_photo'] = i.photo
					data1['count'] = x
					data1['id'] = i.id
					@home_images.push(data1)
					x=x+1
				end
				if data.count%6 == 0
					@count = true
				end
				@total_count = data.count
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
				@home = Home.find(params[:home_id])
				if request.post?
					@home.address = params[:address]
					@home.home_type = params[:home_type]
					@home.price = params[:price]
					@home.open_house_date = Date.strptime(params[:open_house_date],"%m/%d/%Y")
					@home.open_house_start_time = params[:open_house_start_time]
					@home.open_house_end_time = params[:open_house_end_time]
					@home.beds = params[:beds]
					@home.baths = params[:baths]
					if params[:for_sale] == 'true'
		  				@home.for_sale = true
		  			else
		  				@home.for_sale = false
		  			end
		  			@home.save
					flash[:msg] = "Success! Changes saved Successfully"
					redirect_to "/home/show/"+params[:home_id]
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
	    		@home = Home.find(params[:home_id])
				home_image=HomeImage.where(home_id: @home.id)
				home_image.destroy_all
				@home.destroy
				flash[:msg] = "Success! Home Deleted Successfully"
				redirect_to "/home/index/"
	    	else
	    		redirect_to "/"
	    	end
	    else
			redirect_to "/"
  		end	
	end

	def home_image_add
		@home=Home.find(params[:home_id])
		for i in params[:file]
			HomeImage.create(photo: i[1],home_id: @home.id)
		end
		flash[:msg] = "Success! Image Added Successfully"
		redirect_to "/home/show/"+params[:home_id]
	end

	#remove image from model_campaign
	def home_image_delete
		image = HomeImage.find(params[:image_id])
		image_id = image.home_id
		image.destroy
		flash[:msg] = "Success! Image Deleted Successfully"
		redirect_to "/home/show/"+image_id.to_s
	end

end
