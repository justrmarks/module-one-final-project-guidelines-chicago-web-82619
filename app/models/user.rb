
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
                user.generate_keys if (!File.exist?("secret/public.key") || !File.exist?("secret/private.key"))
                user
            elsif user.password != password
                puts "Incorrect password"
                self.login
            else
                puts "Signing in #{user.name}"
                sleep 2
                user.generate_keys if (!File.exist?("secret/public.key") || !File.exist?("secret/private.key"))
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

    # updates User table foreign key values
    # messages = array of message hashes returned by Slack API from channel: #public_keys
    def self.update_public_keys(messages)
        messages.each do |message|
            data = message["text"].split("\n")
            id = data.shift()
            public_key = data.join("\n")
            user = self.find_by(slack_id: id)
            if (user)
                user.update(public_key: public_key) 
            end
        end
    end

    # instance methods

    def display_messages
        prompt = TTY::Prompt.new
        choices = []
        self.messages.each do |message|
            choices << { 
                name: "#{message.get_poster_name} @ #{message.datetime} in #{message.get_channel_name} \n#{message.text}...\n",
                value: message
            }
        end
        input = prompt.enum_select("Which messages would you like to read?", choices, per_page: 5)
        input.display
    end

    def display_channels
        prompt = TTY::Prompt.new
        choices = self.channels.uniq.map do |channel|
            {name: "#{channel.name} \n #{channel.topic} \n ", value: channel}
        end
        input = prompt.select("Please select a channel", choices)
        
    end

    def generate_keys
        puts "Generating new keys..."
        keypair = Encryption::Keypair.new
        public_key_f = File.open("secret/public.key",'w')
        private_key_f = File.open("secret/private.key", 'w')
        public_key_f.write(keypair.public_key)
        private_key_f.write(keypair.private_key)
        self.update(public_key: keypair.public_key)
        self.share_public_key
    end

    ## posts public keys to channel '#public_keys'
    def share_public_key
        payload = {
            "channel": "#public_keys",
            "text": "#{self.slack_id}\n#{self.public_key}"
        }
        post_header = {
            "Content-type": "application/json",
            "Authorization": "Bearer #{token}"
        }
        post_call = RestClient.post("https://slack.com/api/chat.postMessage", payload, post_header)
        puts "Public key posted in #public_keys"
    end


    

end