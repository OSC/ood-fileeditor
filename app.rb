require 'open3'

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

  # Run the command and capture the stdout, stderr, and exit code as separate variables.
  stdout_str, stderr_str, status = Open3.capture3(@command)

  # Parse the stdout of the command and set the resulting object array to a variable.
  @app_processes = parse_ps(stdout_str)

  # If there was an error performing the command, set it to an error variable.
  @error = stderr_str unless status.success?

  # Variables will be available in views/index.erb
  erb :index
end
