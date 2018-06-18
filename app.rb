require 'sinatra'
require './fileserve.rb'
require 'erb'
require 'pathname'
#require 'dir'
#require 'ood-appkit'

set :erb, :layout => :"layout.html" # use ERB as template engine and keeps the top bar
set :escape_html, true    # safety first!
set :static, true   # in case I feel like making this modular, set this explicitly
set :public_folder, './public'  # same thing
set :views, './views'   # yeah

# fileserve = FileServer.new
# fileserve.run!
# register Sinatra::FileAPI

# get '/fs/*' do
#   fileserve.call(env)
# end

# put '/fs/*' do
#   fileserve.call(env)
# end

# before do
#   @env = env
# end

# serve '/fs/*'

# This might get dangerous, but it's the only way I can see to deliver the js files without Sinatra 404ing
# get '/public/*' do
#   send_file './public/' + params[:splat][0]
# end

get '' do
  redirect to('/edit/'), 301
end

get '/' do
  redirect to('/edit/'), 301
end

get '/edit' do
  redirect to('/edit/'), 301
end

# sends the file as plaintext
# get '/file/*' do
#   send_file '/' + params[:splat][0]
# end

get '/edit/*' do

  path = params[:splat][0] || "/"
  path = "/" + path unless path.start_with?("/")

  @pathname = Pathname.new(path)
  if @pathname.file? && @pathname.readable?
    fileinfo = %x[ file -b --mime-type #{@pathname.to_s.shellescape} ]
    if fileinfo =~ /text\/|\/(x-empty|(.*\+)?xml)/ || params.has_key?(:force)
      @editor_content = ""
      #@file_api_url = OodAppkit.files.api(path: @pathname).to_s
      #borrowing from the running file explorer app
      #will probably break on a different system
      @file_api_url = '/pun/sys/files/api/v1/fs' + path
    else
      @invalid_file_type = fileinfo
      # erb :"404.html"
      halt 404
    end
  elsif @pathname.directory?
    @directory_content = Dir.glob(@pathname + "*").sort
    @file_edit_url = Pathname.new(env['SCRIPT_NAME']).join('edit')
  else
    @not_found = true
    # erb :"404.html"
    halt 404
  end

  # Render the view
  erb :"edit.html"
end

get '/pages/index' do
  erb :"index.html"
end

get '/pages/about' do
  erb :"about.html"
end

not_found do
  erb :"404.html"
end

error 500 do
  erb :"500.html"
end

error 422 do
  erb :"422.html"
end
