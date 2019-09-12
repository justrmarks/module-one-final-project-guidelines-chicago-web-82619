require_relative '../config/environment'
require_relative 'menu.rb'

# gem install rest-client
require 'rest-client'
require 'json'
require 'pry'

a = Artii::Base.new :font => "slant"
puts a.asciify('Welcome')
puts a.asciify('  To')
puts Rainbow(a.asciify('    SLapi'))
puts "\n"
user = User.login
menu = Menu.new(user)
menu.main_menu