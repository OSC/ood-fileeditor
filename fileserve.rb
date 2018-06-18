# my lame attempt at imitating the File Explorer API

require 'sinatra/base'
# require 'IO'

module Sinatra
    module FileAPI
        def serve(route)
		get route do
			path = params[:splat][0] || "/"
			path = "/" + path unless path.start_with?("/")

			if !params[:size].nil?
				# return file or dir size
			elsif !params[:time].nil?
				# return time of file or dir
			elsif !params[:hash].nil?
				# return SHA-1 hash
			# beautify? minify? they kinda sound silly
			else
				send_file path
			end
		end

		put route do
			# fancy stuff
		end

                # case env["REQUEST_METHOD"]
                # when "GET"
                #     response[2] = IO.binread('/' + params[:splat][0])
                # when "PUT"
                #     result_code = IO.binwrite('/' + params[:splat][0])
                #     response[2] = "The file was written with result code #{result_code}"
                # end
        end
    end
    module FileHelpers
        #url fixer, to allow for crazy file names
        #Unix only disallows '\0' (null byte) and '/' in file and folder names
        
        #MIME type generator

    end
    # register FileAPI
end

# class FileServer < Sinatra::Base
    # helpers Sinatra::FileHelpers
    # register Sinatra::FileAPI
# end
