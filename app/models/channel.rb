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
                    name: channel["name"],
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
                ts: Time.at(message["ts"].to_f),
                user_id: user.slack_id,
                text: message["text"],
                channel_id: self.slack_id,
                subtype: message["subtype"]                
            })
           else
            Message.find_or_create_by({
                ts: Time.at(message["ts"].to_f),
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
            p message.get_poster_name
            choices << { 
                name: "#{message.get_poster_name} @ #{message.datetime} in #{message.get_channel_name}\n#{message.text}...\n",
                value: message
            }
        end
        input = prompt.enum_select("Which messages would you like to read?", choices, per_page: 5)
        input.display
    end

    def post_message(user)
        prompt = TTY::Prompt.new
        input = prompt.ask("Type your message: ")
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

end