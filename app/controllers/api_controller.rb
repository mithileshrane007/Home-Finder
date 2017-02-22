class ApiController < ApplicationController
	def notification_test
		token = params[:token]
		message ="hi"
		device = "ios"
		response =  notification(token,message,device)
		data ={}
		data['error'] = 'false'
		data['msg'] = 'success'
		data['response']=response
		respond_to do |format|
	      format.json { render json: data }
	    end
	end
	
	def login
		user = User.find_by_email(params[:email])
	    if user && user.authenticate(params[:password])
	      	data ={}
			data['error'] = 'false'
			data['msg'] = 'success'
			data['result'] = {}
			data['result']['username'] = user.username
			data['result']['name'] = user.name
			data['result']['email'] = user.email
			data['result']['user_id'] = user.id
			if user.is_guest
				data['result']['user_type'] = "is_guest"
			elsif user.is_host
				data['result']['user_type'] = "is_host"
			elsif user.is_realtor
				data['result']['user_type'] = "is_realtor"
			end
			data['result']['phone_number'] = user.phone_number
			if not user.photo.blank?
				data['result']['photo'] = user.photo(:small)
			else
				data['result']['photo'] = ''
			end
			data['result']['company'] = user.company
	    else 
	      	data ={}
		  	data['error'] = 'true'
		  	data['msg'] = 'Invalid email/password combination'
	    end
	    
		respond_to do |format|
	      format.json { render json: data }
	    end


	end

	def guest_signup
		
		user = User.find_by_email(params[:email])
		if not user
			name = params[:name]
			o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
		    string = (0..4).map { o[rand(o.length)] }.join
			username = name+string
			email = params[:email]
			user= User.new(username: username,email: email,name: name,created_date: DateTime.now.to_date,phone_number: params[:phone_number],company: params[:company],is_guest: true)  
			user.password_digest = BCrypt::Password.create(params[:password])
			user.save

			data ={}
		  	data['error'] = 'false'
		  	data['msg'] = 'signup successful'
		  	data['result'] = {}
			data['result']['username'] = user.username
			data['result']['name'] = user.name
			data['result']['email'] = user.email
			data['result']['user_id'] = user.id
			data['result']['user_type'] = 'is_guest'
			data['result']['phone_number'] = user.phone_number
			if not user.photo.blank?
				data['result']['photo'] = user.photo(:small)
			else
				data['result']['photo'] = ''
			end
			data['result']['company'] = user.company
		else 
	      	data ={}
		  	data['error'] = 'true'
		  	data['msg'] = 'Email already exist'
	    end
	    
		respond_to do |format|
	      format.json { render json: data }
	    end
	end

	def add_home
		if params[:user_id].blank?
			user = User.find_by_email(params[:email])
			if not user
				name = params[:name]
				o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
			    string = (0..4).map { o[rand(o.length)] }.join
				username = name+string
				email = params[:email]
				user= User.new(username: username,email: email,name: name,created_date: DateTime.now.to_date,phone_number: params[:phone_number],company: params[:company])
				if not params[:is_host].blank? 
					user.is_host = true
				elsif not params[:is_realtor].blank?
					user.is_realtor = true
				end
					
				user.password_digest = BCrypt::Password.create(params[:password])
				user.save
			end
		else
			user = User.find(params[:user_id])
		end
		
		address=params[:address]
		description=params[:description]     
    	open_house_date = Date.strptime(params[:open_house_date],"%m/%d/%Y")
    	open_house_start_time = DateTime.strptime(params[:open_house_date]+" "+params[:open_house_start_time],"%m/%d/%Y %I:%M %p") 
    	open_house_end_time = DateTime.strptime(params[:open_house_date]+" "+params[:open_house_end_time],"%m/%d/%Y %I:%M %p") 
    	if params[:for_sale]=='true'
    		for_sale = true
    	else
    		for_sale = false
    	end
    	price = params[:price]
    	title = params[:title]
		home = Home.create(address: address,description: description,open_house_date: open_house_date,open_house_start_time: open_house_start_time,open_house_end_time: open_house_end_time,for_sale: for_sale,beds: params[:beds],baths: params[:baths],home_type: params[:home_type],price: params[:price],title: title,user_id: user.id)
		if not params[:photo].blank?
			for i in params[:photo]
				StringIO.open(Base64.decode64(i[1])) do |data|
			      data.class.class_eval { attr_accessor :original_filename, :content_type }
			      data.original_filename = "file.jpg"
			      data.content_type = "image/jpeg"
			      puts data.inspect
			      image = HomeImage.create(photo: data,home_id: home.id)
			      image.inspect
			    end
			
				puts "============"
				 
			end

		end
		
		data1 = {}
		data1['user_id'] = user.id
		data1['email'] = user.email
		data1['name']=  user.name
		data1['phone_number']=  user.phone_number
		data1['company']= user.company
		if not user.photo.blank?
			data1['photo'] = user.photo(:small)
		else
			data1['photo'] = ''
		end
		data ={}
		data['error'] = 'false'
		data['msg'] = 'success'
		data['results'] = data1

		respond_to do |format|
	      format.json { render json: data }
	    end
	end

	def filter
		puts params[:device_datetime]
		datetime_now=DateTime.parse((params[:device_datetime]).to_s)
		puts datetime_now
		date_now= datetime_now.to_date
		home_ids = Home.all.pluck(:id)
		homes = Home.all
      	if not params[:min].blank?
      		home_ids= home_ids & (Home.where("price >= ?",(params[:min]).to_i).pluck(:id))
      	end

      	if not params[:max].blank?
      		home_ids= home_ids & (Home.where("price <= ?",(params[:max]).to_i).pluck(:id))
      	end

      	if not params[:home_type].blank?
      		home_ids= home_ids & (Home.where(home_type: params[:home_type]).pluck(:id))
      	end

      	if not params[:beds].blank?
      		home_ids= home_ids & (Home.where("beds >= ?",params[:beds]).pluck(:id))
      	end

      	if not params[:baths].blank?
      		home_ids= home_ids & (Home.where("baths >= ?",params[:baths]).pluck(:id))
      	end
      	
      	if not params[:open_date].blank?
      		if params[:open_date] == 'today'
      			home_ids= home_ids & (Home.where("open_house_date = ?", date_now).pluck(:id))
      		end
      		if params[:open_date] == 'upcoming'
      			home_ids= home_ids & (Home.where("open_house_date >= ? and open_house_date <= ? ",date_now,date_now + 7).pluck(:id))
      		end
      		
      	end


      	end_index = ((params[:page]).to_i*10)-1
	    start_index = end_index - 9
      	puts Home.where("id IN (?)",home_ids).inspect
      	puts "============"
      	if not params[:latitude].blank? and not params[:longitude].blank?
			lat = params[:latitude]
			lng = params[:longitude]
			if params[:is_map].blank?
				puts "in lat map"
	        	homes = Home.near([lat,lng],50, :order => 'distance').where("id IN (?) and open_house_end_time >= ?",home_ids,datetime_now).order('id DESC')[start_index..end_index]
	        else
	        	puts "in lat not map"
	        	homes = Home.near([lat,lng],50, :order => 'distance').where("id IN (?) and open_house_end_time >= ? ",home_ids,datetime_now).order('id DESC')
	        end
      	else
      		if params[:is_map].blank?
      			puts "in not lat map"
      			homes = Home.where("id IN (?) and open_house_end_time >= ?",home_ids,datetime_now).order('id DESC')[start_index..end_index]
      		else
      			puts "in not lat not map"
      			homes = Home.where("id IN (?) and open_house_end_time >= ?",home_ids,datetime_now).order('id DESC')
      		end
      	end

      	result=[]
      	if not homes.blank?
	      	for i in homes
		      	  data={}
			      data["id"] =i.id
			      data["home_type"] =i.home_type
			      data["address"] =i.address
			      data["description"] =i.description
			      data["open_house_date"] =i.open_house_date.strftime("%m/%d/%Y")
			      if not i.open_house_start_time.blank?
			      	data["open_house_start_time"] =i.open_house_start_time.strftime('%I:%M %p') 
			      else
			      	data["open_house_start_time"] =""
			      end
			      if not i.open_house_start_time.blank?
			      	data["open_house_end_time"] =i.open_house_end_time.strftime('%I:%M %p') 
			      else
			      	data["open_house_end_time"] =""
			      end
			      data["for_sale"] =i.for_sale
			      data["beds"] =i.beds
			      data["baths"] =i.baths
			      data["price"] =i.price
			      data["lat"] =i.lat
			      data["lng"] =i.lng
			      data["title"] =i.title
			      data["host_id"] =i.user_id
			      if not i.user_id.blank?
				      data["host_name"] =i.user.name
				      data["host_photo"] =i.user.photo(:medium)
				  end
			      if not i.home_images.blank?
				      data["image"]=i.home_images.first.photo(:large)
		    	  else
		    	  	  data["image"]=''
		    	  end
		    	  result.push(data)
	      	end	
	      	data ={}
			data['error'] = 'false'
			data['msg'] = 'success'
			data['result'] = result
	    else
	    	data ={}
			data['error'] = 'false'
			data['msg'] = 'no results found'
	    end
      
      	respond_to do |format|
		    format.json { render json: data }
		end
	end

	def home_data
		begin
			home = Home.find(params[:home_id])
			if not home.blank?
				result={}
		      	result["images"]=[]
		      	for i in home.home_images.all
		      		data1={}
		      		data1["photo"] =i.photo(:large)
		      		data1["id"] = i.id
		      		result["images"].push(data1)
		      	end
		      	data ={}
				data['error'] = 'false'
				data['msg'] = 'success'
				data['result'] = result
			else
				data ={}
				data['error'] = 'false'
				data['msg'] = 'no results found'
			end
		rescue Exception => e
			data ={}
			data['error'] = 'false'
			data['msg'] = 'no results found'
		end
		
		respond_to do |format|
		    format.json { render json: data }
		end
	end

	def update_device_token
		
		begin
			user = User.find(params[:user_id])
			user.device_token = params[:device_token]
			user.device_type = params[:device_type]
			user.timezone = params[:timezone]
			user.save
			data ={}
			data['error'] = 'false'
			data['msg'] = 'Token Updated Successfully'
		rescue Exception => e
			data ={}
			data['error'] = 'true'
			data['msg'] = 'no user found'
		end
		respond_to do |format|
		    format.json { render json: data }
		end
	end

	def show_user
		begin
			user = User.find(params[:user_id])
			data1 = {}
			data1['user_id'] = user.id
			if user.is_guest
				data1['user_type'] = "is_guest"
			elsif user.is_host
				data1['user_type'] = "is_host"
			elsif user.is_realtor
				data1['user_type'] = "is_realtor"
			end
			data1['email'] = user.email
			data1['name']=  user.name
			data1['phone_number']=  user.phone_number
			data1['company']= user.company
			if not user.photo.blank?
				data1['photo'] = user.photo(:small)
			else
				data1['photo'] = ''
			end

			data ={}
			data['error'] = 'false'
			data['msg'] = 'success'
			data['results'] = data1
		rescue Exception => e
			data ={}
			data['error'] = 'true'
			data['msg'] = 'no user found'
		end

		respond_to do |format|
		    format.json { render json: data }
		end
	end

	def edit_user
		user = User.find(params[:user_id])
		if user.email == params[:email]
			user.email = params[:email]
			user.name = params[:name]
			user.phone_number = params[:phone_number]
			user.company = params[:company]
			
			if not params[:photo].blank?

				StringIO.open(Base64.decode64(params[:photo])) do |data|
			      data.class.class_eval { attr_accessor :original_filename, :content_type }
			      data.original_filename = "file.jpg"
			      data.content_type = "image/jpeg"
			      puts data.inspect
			      user.photo = data
			    end
			end
			user.save
			data ={}
			data['error'] = 'false'
			data['msg'] = 'Profile Edited Successfully'
		else
			begin
				User.find_by_email(params[:email]).id
				data ={}
				data['error'] = 'true'
				data['msg'] = 'Email already exist'
			rescue Exception => e
				user.email = params[:email]
				user.name = params[:name]
				user.phone_number = params[:phone_number]
				user.company = params[:company]
				
				if not params[:photo].blank?

					StringIO.open(Base64.decode64(params[:photo])) do |data|
				      data.class.class_eval { attr_accessor :original_filename, :content_type }
				      data.original_filename = "file.jpg"
				      data.content_type = "image/jpeg"
				      puts data.inspect
				      user.photo = data
				    end
				end
				user.save
				data ={}
				data['error'] = 'false'
				data['msg'] = 'Profile Edited Successfully'
			end
		end 

		respond_to do |format|
		    format.json { render json: data }
		end
	end

	def send_message
		begin
			to_user = User.find(params[:to_user_id])
			from_user = User.find(params[:from_user_id])
			obj = Message.create(home_id: params[:home_id],from_user_id:params[:from_user_id],to_user_id: params[:to_user_id],message: params[:message],created_date: Time.now)
			obj.save
			puts obj.errors.inspect
			puts "================"
			
			device = to_user.device_type
			home = Home.find(params[:home_id])
			# if params[:device] == "android"
			# 	device = "android"
			# else
			# 	device = "ios"
			# end
			if not to_user.device_token.blank?
				data={}
				data['message']=params[:message]
				data['photo']=from_user.photo(:medium)
				data['name']=from_user.name
				data['id']=from_user.id
				data['home_id']=params[:home_id]
				data['address']=home.address
				data['created_date']=obj.created_date.in_time_zone(to_user.timezone).strftime("%Y-%m-%d %H:%M:%S")
				response = notification(to_user.device_token,data,device)
			end
			data ={}
			data['error'] = 'false'
			data['msg'] = 'message sent successfully'
			data['response']=response
			data['send_data'] = {}
			data['send_data']['created_date']= obj.created_date.in_time_zone(from_user.timezone).strftime("%Y-%m-%d %H:%M:%S")
			data['send_data']['message']= params[:message] 

		rescue Exception => e
			data ={}
			data['error'] = 'true'
			data['msg'] = 'something went wronge'
		end
		respond_to do |format|
		    format.json { render json: data }
		end
	end

	def delete_chat
		message_ids = []
		message_ids = Message.where(home_id: params[:home_id],from_user_id:params[:from_user_id],to_user_id: params[:to_user_id]).pluck(:id)
		message_ids = message_ids | Message.where(from_user_id:params[:to_user_id],to_user_id: params[:from_user_id]).pluck(:id)
		messages = Message.where(id: message_ids)
		messages.destroy_all
		data ={}
		data['error'] = 'false'
		data['msg'] = 'success'
		respond_to do |format|
		    format.json { render json: data }
		end
	end

	def fetch_message
		message_ids = []
		from_user = User.find(params[:from_user_id])
		message_ids = Message.where(home_id: params[:home_id],from_user_id:params[:from_user_id],to_user_id: params[:to_user_id]).pluck(:id)
		message_ids = message_ids | Message.where(home_id: params[:home_id],from_user_id:params[:to_user_id],to_user_id: params[:from_user_id]).pluck(:id)
		
		end_index = ((params[:page]).to_i*30)-1
	    start_index = end_index - 29

		messages = Message.where(id: message_ids).order('id DESC')[start_index..end_index]
		

		if not messages.blank?
			results = []
			for i in messages
				data1={}
				data1['id'] = i.id
				data1['from_user_id'] = i.from_user_id
				data1['to_user_id'] = i.to_user_id
				data1['message'] = i.message
				if not i.created_date.blank?
					data1['created_date'] = i.created_date.in_time_zone(from_user.timezone).strftime("%Y-%m-%d %H:%M:%S")
				else
					data1['created_date'] = 'null'
				end
				results.push(data1)
			end
			data ={}
			data['error'] = 'false'
			data['msg'] = 'success'
			data['result'] = results
		else
			data ={}
			data['error'] = 'true'
			data['msg'] = 'no data found'
		end
		respond_to do |format|
		    format.json { render json: data }
		end
	end

	def fetch_user_chat
		messages = Message.where("from_user_id = :user_id OR to_user_id = :user_id",:user_id => params[:user_id]).order('created_date DESC')
		main_user = User.find(params[:user_id])
		# message_ids = message_ids | Message.where(to_user_id: params[:user_id]).pluck(:from_user_id)
		# messages = User.where(id: message_ids)
		data ={}
		data['error'] = 'false'
		data['msg'] = 'success'
		results = []
		for i in messages
			data1={}
			if (i.from_user_id).to_i == (params[:user_id]).to_i
				
				user = User.find(i.to_user_id)
				home = Home.find(i.home_id)
				if not results.any? {|h| h['id'] == user.id and h['home_id'] == home.id}
					data1['id'] = user.id
					data1['home_id'] = i.home_id
					data1['address'] = home.address
					data1['name'] = user.name
					if not user.photo.blank?
						data1['photo'] = user.photo(:medium)
					else
						data1['photo'] = ""
					end
					data1['message'] = i.message
					if not i.created_date.blank?
						data1['created_date'] = i.created_date.in_time_zone(main_user.timezone).strftime("%Y-%m-%d %H:%M:%S")
					else
						data1['created_date'] = 'null'
					end
					results.push(data1)
				end
			else
				user = User.find(i.from_user_id)
				home = Home.find(i.home_id)
				if not results.any? {|h| h['id'] == user.id and h['home_id'] == home.id}
					data1['id'] = user.id
					data1['home_id'] = i.home_id
					data1['address'] = home.address
					data1['name'] = user.name
					if not user.photo.blank?
						data1['photo'] = user.photo(:medium)
					else
						data1['photo'] = ""
					end
					data1['message'] = i.message
					if not i.created_date.blank?
						data1['created_date'] = i.created_date.in_time_zone(main_user.timezone).strftime("%Y-%m-%d %H:%M:%S")
					else
						data1['created_date'] = 'null'
					end
					results.push(data1)
				end
			end
			

		end
		puts results
		

		data['result'] = results
		respond_to do |format|
		    format.json { render json: data }
		end
	end

	def logout
		begin
			user = User.find(params[:user_id])
			user.device_token = ""
			user.save
			data ={}
			data['error'] = 'false'
			data['msg'] = 'token deleted successfully'
		rescue Exception => e
			data ={}
			data['error'] = 'true'
			data['msg'] = 'no data found'
		end
		respond_to do |format|
		    format.json { render json: data }
		end
	end

	def fetch_after_date
		messages = Message.where("from_user_id = :user_id OR to_user_id = :user_id",:user_id => params[:user_id]).order('created_date DESC')
		user = User.find(params[:user_id])
		results = []
		if not messages.blank?
			for i in messages
				if i.created_date.in_time_zone(user.timezone) > DateTime.parse(params[:date_greater_then]).in_time_zone(user.timezone)
					home = Home.find(i.home_id)
					data1={}
					data1['id'] = i.id
					data1['from_user_id'] = i.from_user_id
					data1['to_user_id'] = i.to_user_id
					data1['message'] = i.message
					data1['home_id'] = i.home_id
					data1['address'] = home.address
					if not i.created_date.blank?
						data1['created_date'] = i.created_date.in_time_zone(user.timezone).strftime("%Y-%m-%d %H:%M:%S")
					else
						data1['created_date'] = 'null'
					end
					results.push(data1)
				end
			end
			data ={}
			data['error'] = 'false'
			data['msg'] = 'success'
			data['results'] = results
		else
			data ={}
			data['error'] = 'true'
			data['msg'] = 'no data found'
		end
		respond_to do |format|
		    format.json { render json: data }
		end
	end

	def user_homes
		homes = Home.where(user_id: params[:user_id]).order('id DESC')
      	result=[]
      	if not homes.blank?
	      	for i in homes
	      	  data={}
		      data["id"] =i.id
		      data["home_type"] =i.home_type
		      data["address"] =i.address
		      data["description"] =i.description
		      data["open_house_date"] =i.open_house_date.strftime("%m/%d/%Y")
		      if not i.open_house_start_time.blank?
		      	data["open_house_start_time"] =i.open_house_start_time.strftime('%I:%M %p') 
		      else
		      	data["open_house_start_time"] =""
		      end
		      if not i.open_house_start_time.blank?
		      	data["open_house_end_time"] =i.open_house_end_time.strftime('%I:%M %p') 
		      else
		      	data["open_house_end_time"] =""
		      end
		      data["for_sale"] =i.for_sale
		      data["beds"] =i.beds
		      data["baths"] =i.baths
		      data["price"] =i.price
		      data["lat"] =i.lat
		      data["lng"] =i.lng
		      data["title"] =i.title
		      data["host_id"] =i.user_id
		      if not i.user_id.blank?
			      data["host_name"] =i.user.name
			      data["host_photo"] =i.user.photo(:medium)
			  end
		      if not i.home_images.blank?
			      data["image"]=i.home_images.first.photo(:large)
	    	  else
	    	  	  data["image"]=''
	    	  end
	    	  result.push(data)
	      	end	
	      	data ={}
			data['error'] = 'false'
			data['msg'] = 'success'
			data['result'] = result
	    else
	    	data ={}
			data['error'] = 'false'
			data['msg'] = 'no results found'
	    end
      
      	respond_to do |format|
		    format.json { render json: data }
		end
	end

	def edit_home
		puts "===============o"
		puts params[:home_id]
		puts "===============o"
		puts params[:address]
		home = Home.find(params[:home_id])

		address=params[:address]
		description=params[:description]     
    	open_house_date = Date.strptime(params[:open_house_date],"%m/%d/%Y")
    	open_house_start_time = DateTime.strptime(params[:open_house_date]+" "+params[:open_house_start_time],"%m/%d/%Y %I:%M %p") 
    	open_house_end_time = DateTime.strptime(params[:open_house_date]+" "+params[:open_house_end_time],"%m/%d/%Y %I:%M %p") 
    	if params[:for_sale]=='true'
    		for_sale = true
    	else
    		for_sale = false
    	end
    	price = params[:price]
    	title = params[:title]

		home.address=  address
		home.description = description
		home.open_house_date = open_house_date
		home.open_house_start_time = open_house_start_time
		home.open_house_end_time = open_house_end_time
		home.for_sale = for_sale
		home.beds = params[:beds]
		home.baths = params[:baths]
		home.home_type = params[:home_type]
		home.price = params[:price]
		home.title = title
		home.save
		puts home.errors.inspect
		puts "========================"
		data ={}
		data['error'] = 'false'
		data['msg'] = 'success'
		respond_to do |format|
		    format.json { render json: data }
		end
	end

	def delete_home
		home = Home.find(params[:home_id])
		home_image=HomeImage.where(home_id: home.id)
		home_image.destroy_all
		messages = Message.where(home_id: params[:home_id])
		messages.destroy_all
		home.destroy
		data ={}
		data['error'] = 'false'
		data['msg'] = 'success'
		respond_to do |format|
		    format.json { render json: data }
		end
	end

	def delete_image
		home_image = HomeImage.find(params[:home_image_id])
		home_image.destroy
		data ={}
		data['error'] = 'false'
		data['msg'] = 'success'
		respond_to do |format|
		    format.json { render json: data }
		end
	end

	def add_image
		data2 ={}
		data2["images"] =[]
		if not params[:photo].blank?
			for i in params[:photo]
				StringIO.open(Base64.decode64(i[1])) do |data|
			      data.class.class_eval { attr_accessor :original_filename, :content_type }
			      data.original_filename = "file.jpg"
			      data.content_type = "image/jpeg"
			      puts data.inspect
			      image = HomeImage.create(photo: data,home_id: params[:home_id])
			      image.inspect
			      data1={}
		      	  data1["photo"] =image.photo(:large)
		      	  data1["id"] = image.id
		      	  data2["images"].push(data1)
			    end			
				puts "============"
			end

		end
		
		data2['error'] = 'false'
		data2['msg'] = 'success'
		respond_to do |format|
		    format.json { render json: data2 }
		end
	end

	def email_validate
		user = User.find_by_email(params[:email])
		if not user
			data ={}
		  	data['error'] = 'false'
		  	data['msg'] = 'Email dose not exist'
		else 
	      	data ={}
		  	data['error'] = 'true'
		  	data['msg'] = 'Email already exist'
	    end
	    
		respond_to do |format|
	      format.json { render json: data }
	    end
	end

end
