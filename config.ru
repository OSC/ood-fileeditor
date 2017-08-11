require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  # Define your variables
  @title = "Currently Running OnDemand Passenger Apps"
  @command = "ps aux | grep App | grep -v grep"
  @output  = `#{@command}`

  # Variables will be available in views/index.erb
  erb :index
end

run Sinatra::Application
