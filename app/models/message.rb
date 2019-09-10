class Message < ActiveRecord::Base
    belongs_to :user, :foreign_key => "user_slack_id"
    belongs_to :channel, :foreign_key => "channel_slack_id"

    

end