class Message < ActiveRecord::Base
    belongs_to :user, :foreign_key => "user_id"
    belongs_to :channel, :foreign_key => "channel_id"

    def get_poster_name
        User.all.find_by(slack_id: self.user_id).name
    end

    def datetime
        Time.at(self.ts.to_f).strftime("%H:%M")
    end

end