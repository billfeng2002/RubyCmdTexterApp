require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')

if Dir.pwd.split("/")[-1] == "config"
  require_all '../app'
else
  require_all 'app'
end