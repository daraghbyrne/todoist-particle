require "sinatra"
require 'sinatra/reloader' if development?
require 'alexa_skills_ruby'
require 'httparty'
require 'iso8601'
require 'json'
require 'particlerb'

# ----------------------------------------------------------------------

# Load environment variables using Dotenv. If a .env file exists, it will
# set environment variables from that file (useful for dev environments)
configure :development do
  require 'dotenv'
  Dotenv.load
end

# enable sessions for this project
enable :sessions



get "/" do
	404
end

post "/incoming/todoist/" do
	
  payload = params
  payload = JSON.parse(request.body.read).symbolize_keys unless params[:path]

  logger.info "Saving #{payload[:event_name]} with #{payload[:meta]}"

  file = load_app.sitemap.find_resource_by_path payload[:path]
	
	puts params.to_json
	
	200
end

get "/todoist/summary" do
	
	todoist_url = "https://beta.todoist.com/API/v8/tasks"

  api_key = ENV['TODOIST_ACCESS_TOKEN']
  
  response = HTTParty.get todoist_url, headers: {'Authorization' => "Bearer #{ ENV['TODOIST_ACCESS_TOKEN'] }"}
	
	# puts response.size
	# puts response.to_yaml
	# puts response.size
	
	# return the total count
	
	count = response.size
	count.to_s
	
	todays_count = 0
	
	response.each do |item|
		
		puts item
		if defined? item["due"] and not item["due"].nil?
			if item["due"]["date"] == Time.now.strftime('%Y-%m-%d')
				todays_count = todays_count + 1
			end
		end 
	end
	
	return count.to_s + "," + todays_count.to_s
	
end 

private 

def particle_publish_event event_name, data_str

  # create a client
  client = Particle::Client.new(access_token: ENV['PARTICLE_ACCESS_TOKEN'])
  
  # list devicces
  # client.devices
  
  client.publish(name: event_name.to_s , data: data_str.to_s , ttl: 60, private: false )
  
end 
