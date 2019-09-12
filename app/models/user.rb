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
                    email: member["profile"]["email"],
                    display_name: member["profile"]["display_name"]
                })
            end
        end
    end

    #method to authenticate user and return a user instance
    def self.login
        prompt = TTY::Prompt.new
        name = prompt.ask("Please enter your slack display name: ")
        user = all.find_by(display_name: name)
        pizza = prompt.decorate('🍕 ')
        if user
            password = prompt.mask("Please enter a password:", mask: pizza)
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

    def self.display_messages_by_user
        prompt = TTY::Prompt.new
        input = prompt.ask("Enter a user's name: ")
        user = self.find_by(display_name: input)
        if user
            user.display_messages
        else
            "Invalid user name"
            self.display_messages_by_user
        end
    end

    # instance methods

    def display_messages
        prompt = TTY::Prompt.new
        choices = []
        self.messages.each do |message|
            time = Time.at(message.ts.to_f)
            choices << { 
                name: Rainbow("#{message.get_poster_name} @ #{time.strftime("%I:%M %p")} in #{message.get_channel_name}").color(message.get_color) +  "\n#{message.text}...\n",
                value: message
            }
        end
        input = prompt.select("Which message would you like to read?") do |menu|
            choices.map do |c|
                menu.choice c, c
            end
        end
        input.display
    end

    def display_channels
        prompt = TTY::Prompt.new
        choices = self.channels.uniq.map do |channel|
            {name: "#{channel.name} \n #{channel.topic} \n ", value: channel}
        end
        input = prompt.select("Please select a channel", choices)
        
    end

end