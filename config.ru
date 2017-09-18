require 'sinatra'
require 'sinatra/reloader' if development?
require 'erubi'

set :erb, :escape_html => true

require './app'

run Sinatra::Application
