class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  puts "+++++++++++++++s"
  def notification(token,data,device)
    require 'fcm'
	fcm = FCM.new("AIzaSyBWwfz43QlR3f77LZbgaz_QXEKiv9Y36eA")
	# you can set option parameters in here
	#  - all options are pass to HTTParty method arguments
	#  - ref: https://github.com/jnunemaker/httparty/blob/master/lib/httparty.rb#L29-L60
	#  fcm = FCM.new("my_api_key", timeout: 3)
	# registration_ids= ["12", "13"] # an array of one or more client registration tokens
	

	if device=="android"
		options = {data: {body: data,flag: 1},priority: "high"}
	else
		options = {data: {body: data,flag: 1}, notification: {title: "Message Received",body: data['message'],content_available: true,sound: 'default',is_background: true},priority: "high",sound: 'default'}
	end
	

	puts options
	response = fcm.send([token], options)
	puts "==========="
	return response
	puts "==========="
  end
end
