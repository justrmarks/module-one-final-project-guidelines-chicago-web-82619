class Channel < ActiveRecord::Base
    has_many :messages
    has_many :users, through: :messages
    self.primary_key = "slack_id"

#   Class Methods

    def self.update_channels
        data = JSON.parse(RestClient.get("https://slack.com/api/channels.list?token=#{token}"))
        data["channels"].each do |channel|
            if channel["is_archived"]
                Channel.destroy(Channel.find_by(slack_id: channel["id"]).id)
            else
                Channel.find_or_create_by({
                    slack_id: channel["id"],
                    name: "##{channel["name"]}",
                    topic: channel["topic"]["value"]
                })
            end
        end
    end

#   Instanace Methods

    def update_messages
        data = JSON.parse(RestClient.get("https://slack.com/api/channels.history?token=#{token}&channel=#{self.slack_id}"))
        data["messages"].each do |message|
           if message["user"] == "cli_input" # replace with variable stored in environment.rb later
            user = User.find_by(message["text"].split("*")[1])
            Message.find_or_create_by({
                ts: message["ts"],
                user_id: user.slack_id,
                text: message["text"],
                channel_id: self.slack_id,
                subtype: message["subtype"]                
            })
           else
            Message.find_or_create_by({
                ts: message["ts"],
                user_id: message["user"],
                text: message["text"],
                channel_id: self.slack_id,
                subtype: message["subtype"]
            })
        end
        end
    end

    def display_messages
        choices = []
        prompt = TTY::Prompt.new
        self.messages.each do |message|
            time = Time.at(message["ts"].to_f)
            color = message.get_color
            if color == nil
                color = "ffffff"
            end
            choices << { 
                name: Rainbow("#{message.get_poster_name} @ #{time.strftime("%I:%M %p")} in #{message.get_channel_name}").color(color) +  "\n#{message.text}...\n",
                value: message
            }
        end
        input = prompt.select("Which messages would you like to read?".colorize(:blue), choices, per_page: 5, active_color: :inverse)
        input.display
    end

    def post_message(user)
        prompt = TTY::Prompt.new
        input = prompt.ask("\n Type your message: ".colorize(:blue))
        payload = {
            "channel": self.slack_id,
            "text": "*#{user.display_name}* says~ #{input}"
        }
        post_header = {
            "Content-type": "application/json",
            "Authorization": "Bearer #{token}"
        }
        post_call = RestClient.post("https://slack.com/api/chat.postMessage", payload, post_header)
        response = JSON.parse(post_call)
        message = response["message"]
        Message.find_or_create_by(
            ts: message["ts"],
            user_id: user.slack_id,
            text: message["text"].split("~")[1],
            channel_id: self.slack_id,
            subtype: message["subtype"]
        )
    end

    def insights
        system("clear")
        prompt = TTY::Prompt.new
        puts "*" * 40
        puts "*" + " Number of Users: ".colorize(:blue) + "#{self.users.uniq.count}"
        puts "*"
        puts "*" + " Number of Posts: ".colorize(:blue) + "#{self.messages.uniq.count}"
        puts "*"
        puts "*" + " Most active user: ".colorize(:blue) + "#{self.most_active_user}"
        puts "*"
        puts "*" + " Least active user: ".colorize(:blue) + "#{self.least_active_user}"
        puts "*" * 40
        prompt.keypress("Press any key to return to main menu")
    end

    def most_active_user
        self.users.uniq.max_by {|user| user.messages.size}.display_name
    end

    def least_active_user
        self.users.uniq.min_by {|user| user.messages.size}.display_name
    end

end