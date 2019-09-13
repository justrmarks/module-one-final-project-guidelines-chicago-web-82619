require_relative '../config/environment'
require_relative 'menu.rb'

# gem install rest-client
require 'rest-client'
require 'json'
require 'pry'

a = Artii::Base.new :font => "slant"


User.update_users
Channel.update_channels
Channel.all.each { |channel| channel.update_messages }

2.times {
system("clear")
puts a.asciify('Welcome')
puts a.asciify('  To')
puts a.asciify('    SLapi')
puts "\n"
sleep(0.05)

system("clear")
puts Rainbow(a.asciify('Welcome')).red
puts a.asciify('  To')
puts a.asciify('    SLapi')
puts "\n"
sleep(0.05)

system("clear")
puts Rainbow(a.asciify('Welcome')).color("FFA500")
puts Rainbow(a.asciify('  To')).red
puts a.asciify('    SLapi')
puts "\n"
sleep(0.05)

system("clear")
puts Rainbow(a.asciify('Welcome')).yellow
puts Rainbow(a.asciify('  To')).color("FFA500")
puts Rainbow(a.asciify('    SLapi')).red
puts "\n"
sleep(0.05)

system("clear")
puts Rainbow(a.asciify('Welcome')).green
puts Rainbow(a.asciify('  To')).yellow
puts Rainbow(a.asciify('    SLapi')).color("FFA500")
puts "\n"
sleep(0.05)

system("clear")
puts Rainbow(a.asciify('Welcome')).blue
puts Rainbow(a.asciify('  To')).green
puts Rainbow(a.asciify('    SLapi')).yellow
puts "\n"
sleep(0.05)

system("clear")
puts Rainbow(a.asciify('Welcome')).color("4b0082")
puts Rainbow(a.asciify('  To')).blue
puts Rainbow(a.asciify('    SLapi')).green
puts "\n"
sleep(0.05)

system("clear")
puts Rainbow(a.asciify('Welcome')).color("EE82EE")
puts Rainbow(a.asciify('  To')).color("4b0082")
puts Rainbow(a.asciify('    SLapi')).blue
puts "\n"
sleep(0.05)

system("clear")
puts Rainbow(a.asciify('Welcome'))
puts Rainbow(a.asciify('  To')).color("EE82EE")
puts Rainbow(a.asciify('    SLapi')).color("4b0082")
puts "\n"
sleep(0.05)

system("clear")
puts Rainbow(a.asciify('Welcome'))
puts Rainbow(a.asciify('  To'))
puts Rainbow(a.asciify('    SLapi')).color("EE82EE")
puts "\n"

}

system("clear")
puts a.asciify('Welcome')
puts a.asciify('  To')
puts a.asciify('    SLapi')
puts "\n"

user = User.login
menu = Menu.new(user)
menu.main_menu