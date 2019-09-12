require_relative 'config/environment'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
  old_logger = ActiveRecord::Base.logger
  ActiveRecord::Base.logger = nil
  Pry.start
end
