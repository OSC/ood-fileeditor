class Command
  attr_accessor :command, :processes, :error

  def initialize
    @command = "ps aux | grep App | grep -v grep"
    @processes = []
  end

  AppProcess = Struct.new(:user, :pid, :pct_cpu, :pct_mem, :vsz, :rss, :tty, :stat, :start, :time, :command)

  # Parse a string output from the `ps aux` command and return an array of
  # AppProcess objects, one per process
  def parse(output)
    lines = output.strip.split("\n")
    lines.map do |line|
      AppProcess.new(*(line.split(" ", 11)))
    end
  end

  def to_s
    command
  end

  def exec
    stdout_str, stderr_str, status = Open3.capture3(command)
    if status.success?
      self.processes = parse(stdout_str)
    else
      self.error = "Command '#{command}' exited with error: #{stderr_str}"
    end
  end
end
