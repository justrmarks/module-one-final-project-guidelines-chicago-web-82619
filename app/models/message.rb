class Message < ActiveRecord::Base
    belongs_to :user, :foreign_key => "user_id"
    belongs_to :channel, :foreign_key => "channel_id"

    

end