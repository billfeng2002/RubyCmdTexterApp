require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')

if Dir.pwd.split("/")[-1] == "config"
  require_all '../lib'
else
  require_all 'lib'
end