require 'sinatra'
require 'erb'
require 'pathname'

set :layout, false
set :escape_html, true    # safety first!

helpers do
    def files_api_url(path)
        files_url = ENV['OOD_FILES_URL'] || "/pun/sys/files"
        "#{files_url}/api/v1/fs#{path}"
    end

    def favicon_url
        ENV['OOD_FAVICON_URL'] || env['SCRIPT_NAME'] + "/favicon.ico"
    end
end

get '' do
    redirect to('/edit/'), 301
end

get '/' do
    redirect to('/edit/'), 301
end

get '/edit' do
    redirect to('/edit/'), 301
end

get '/edit/*' do

    path = params['splat'][0] || "/"
    path = "/" + path unless path.start_with?("/")

    @pathname = Pathname.new(path)
    if @pathname.file? && @pathname.readable?
        fileinfo = %x[ file -b --mime-type #{@pathname.to_s.shellescape} ]
        if fileinfo =~ /text\/|\/(x-empty|(.*\+)?xml)/ || params.has_key?('force')
            @editor_content = ""
            @file_api_url = files_api_url(path)
            @filename = @pathname.basename
        else
            @invalid_file_type = fileinfo
            halt 415
        end
    elsif @pathname.directory?
        @directory_content = Dir.glob(@pathname + "*").sort
        @file_edit_url = Pathname.new(env['SCRIPT_NAME']).join('edit')
        halt 422
    elsif @pathname.file? && !@pathname.readable?
        halt 403
    else
        @not_found = true
        halt 404
    end

    # Render the view
    erb :edit
end

# general 404 and file/directory not found with /edit in path
not_found do
    erb :"404"
end

# user does not have read permissions for file
error 403 do
    erb :"403"
end

# non-plaintext file
error 415 do
    erb :"415"
end

# path is a directory
error 422 do
    erb :"422"
end

# server error
error 500 do
    erb :"500"
end
