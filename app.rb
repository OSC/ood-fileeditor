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
  @app_processes = []

  # Run the command and capture the stdout, stderr, and exit code as separate variables.
  stdout_str, stderr_str, status = Open3.capture3(@command)
  if status.success?
    @app_processes = parse_ps(stdout_str)
  else
    @error = "Command '#{@command}' exited with error: #{stderr_str}"
  end

  # Render the view
  erb :index
end
