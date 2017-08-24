require 'sinatra'
require 'sinatra/reloader' if development?
require 'open3'
require 'erubi'

set :erb, :escape_html => true

helpers do
  def parse_ps(ps_string)
    ps_string.split("\n").map { |line| line.split(" ", 11) }
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
