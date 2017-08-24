require 'sinatra'
require 'sinatra/reloader' if development?
require 'open3'
require 'erubi'

set :erb, :escape_html => true

# There are 11 data values for each `ps` item. Here, we create a Struct object to map
#  each value to a named parameter.
AppProcess = Struct.new(:user, :pid, :pct_cpu, :pct_mem, :vsz, :rss, :tty, :stat, :start, :time, :command)

helpers do

  # This command will parse a string output from the `ps` command and map it to
  #  an array of AppProcess objects.
  def parse_ps(ps_string)
    ps_string.split("\n").map { |line| AppProcess.new(*(line.split(" ", 11))) }
  end
end

# Define a route at the root '/' of the app.
get '/' do
  # Define your variables that will be sent to the view.
  @title = "Currently Running OnDemand Passenger Apps"
  @command = "ps aux | grep App | grep -v grep"
  stdout_str, stderr_str, status = Open3.capture3(@command)

  @output = parse_ps(stdout_str)
  @error = stderr_str unless status.success?

  # Variables will be available in views/index.erb
  erb :index
end

run Sinatra::Application
