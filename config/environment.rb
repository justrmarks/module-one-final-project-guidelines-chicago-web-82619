require 'bundler'
Bundler.require

def token
    token = "xoxp-747869875793-756141399111-757227574870-afeac009f56b2e827d406f08d0a489dc"
end

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
require_all 'app'