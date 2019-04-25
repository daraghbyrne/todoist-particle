require "sinatra"
require 'sinatra/reloader' if development?
require 'alexa_skills_ruby'
require 'httparty'
require 'iso8601'
require 'json'
#
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

post "/incoming/todoist/"

	

	200

end



def particle_publish_event event_name, data_str

  # create a client
  client = Particle::Client.new(access_token: ENV['PARTICLE_ACCESS_TOKEN'])
  
  # list devicces
  # client.devices
  
  client.publish(name: event_name.to_s , data: data_str.to_s , ttl: 60, private: false )
  
end 
