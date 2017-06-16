require 'sinatra'

get '/' do
  command = "ps aux | grep App | grep -v grep"
  erb :index, locals: { output: `#{command}`, command: command }
end

run Sinatra::Application
