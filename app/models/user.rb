class User < ActiveRecord::Base
    has_many :messages
    has_many :channels, through: :messages
    self.primary_key = "slack_id"


#   Class Methods

    # method to update database with user name and id
    def self.update_users
        data = JSON.parse(RestClient.get("https://slack.com/api/users.list?token=#{token}"))
        data["members"].each do |member|
            if member["deleted"]
                User.destroy(User.find_by(slack_id: member["id"]).id)
            else
                User.find_or_create_by({
                    slack_id: member["id"],
                    name: member["name"],
                    color: member["color"],
                    email: member["profile"]["email"]
                })
            end
        end
    end

    #method to authenticate user and return a user instance
    def self.login
        prompt = TTY::Prompt.new
        puts "Please enter name:"
        name = gets.chomp
        user = all.find_by(name: name)
        if user
            password = prompt.mask("Please enter a password:")
            if !user.password
                puts "Setting your password...."
                user.update(password: password)
                user
            elsif user.password != password
                puts "Incorrect password"
                self.login
            else
                puts "Signing in #{user.name}"
                sleep 2
                user
            end
        else
            puts "No user found."
            self.login
        end
    end

    # instance methods

    def display_messages(cursor=0)
        choices = []
        prompt = TTY::Prompt.new
        self.messages.each do |message|
            choices << { 
                name: "Poster: #{message.get_poster_name} Time: #{message.datetime} \n#{message.text[0..100]}...\n",
                value: message
            }
        end
        input = prompt.enum_select("Which messages would you like to read?", choices, per_page: 5)
        input.display
    end

end