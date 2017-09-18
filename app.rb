require 'open3'

# There are 11 data values for each `ps` item. Here, we create a Struct object to map
#  each value to an attribute on the Struct
AppProcess = Struct.new(:user, :pid, :pct_cpu, :pct_mem, :vsz, :rss, :tty, :stat, :start, :time, :command)

helpers do
  def title
    "Currently Running OnDemand Passenger Apps"
  end

  # Parse a string output from the `ps aux` command and return an array of
  # AppProcess objects, one per process
  def parse_ps(ps_string)
    ps_string.split("\n").map { |line| AppProcess.new(*(line.split(" ", 11))) }
  end
end

# Define a route at the root '/' of the app.
get '/' do
  # Define variables that will be available in the view
  @command = "ps aux | grep App | grep -v grep"
  @app_processes = []

  # Run the command, and parse the output
  stdout_str, stderr_str, status = Open3.capture3(@command)
  if status.success?
    @app_processes = parse_ps(stdout_str)
  else
    @error = "Command '#{@command}' exited with error: #{stderr_str}"
  end

  # Render the view
  erb :index
end
