class Channel < ActiveRecord::Base
    has_many :messages
    has_many :users, through: :messages

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
                ts: message["ts"],
                user_slack_id: message["user"],
                text: message["text"],
                channel_slack_id: self.slack_id,
                subtype: message["subtype"]
            })
        end

    end

end