require 'bundler'
require 'time'
require 'date'
Bundler.require

def token
    token = File.read("./secret/token.env")
end

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
require_all 'app'