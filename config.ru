require 'sinatra'
require 'dotenv'

require './app'

Dotenv.load
Dotenv.load '/etc/ood/config/apps/file-editor/env' if ENV['PASSENGER_ENV'] == 'production'
run Sinatra::Application
