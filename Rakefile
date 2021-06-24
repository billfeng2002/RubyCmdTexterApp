require_relative './config/environment'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end

desc 'start the app and console'
task :app do
  App.new_session
  #Pry.start
end