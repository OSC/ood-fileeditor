require 'sinatra'
require 'erubi'

set :erb, :escape_html => true

require './app'

run Sinatra::Application
