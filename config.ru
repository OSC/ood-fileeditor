require 'sinatra'
require 'sinatra/reloader' if development?
require 'open3'

helpers do
  def parse_ps(ps_string)
    #output_arr = ps_string.split(/\n/).map { |s| s.split(" ") }
    ps_string.scan(/([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+(.*)/)
  end
end

get '/' do
  # Define your variables
  @title = "Currently Running OnDemand Passenger Apps"
  @command = "ps aux | grep App | grep -v grep"
  stdout_str, stderr_str, status = Open3.capture3(@command)
  @output = parse_ps(stdout_str)
  @error = stderr_str unless status.success?

  # Variables will be available in views/index.erb
  erb :index
end

run Sinatra::Application
