require 'sinatra'
require 'sinatra/reloader' if development?
require 'open3'

get '/' do
  # Define your variables
  @title = "Currently Running OnDemand Passenger Apps"
  @command = "ps aux | grep App | grep -v grep"
  stdout_str, stderr_str, status = Open3.capture3(@command)
  @output = stdout_str
  @error = stderr_str unless status.success?

  # Variables will be available in views/index.erb
  erb :index
end

run Sinatra::Application
