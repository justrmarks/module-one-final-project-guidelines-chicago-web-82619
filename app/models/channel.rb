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
            Message.find_or_create_by({
                ts: Time.at(message["ts"].to_f),
                user_id: message["user"],
                text: message["text"],
                channel_id: self.slack_id,
                subtype: message["subtype"]
            })
        end
    end

    def display_messages
        choices = []
        prompt = TTY::Prompt.new
        self.messages.each do |message|
            p message.get_poster_name
            choices << { 
                name: "#{message.get_poster_name} @ #{message.datetime} in #{message.get_channel_name}\n#{message.text[0..100]}...\n",
                value: message
            }
        end
        input = prompt.enum_select("Which messages would you like to read?", choices, per_page: 5)
        input.display
    end

end