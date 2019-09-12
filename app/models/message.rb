class Message < ActiveRecord::Base
    belongs_to :user, :foreign_key => "user_id"
    belongs_to :channel, :foreign_key => "channel_id"

    def get_poster_name
        user = User.find_by(slack_id: self.user_id)
        if user 
            user.display_name
        end
    end 
    
    def get_color
        user = User.find_by(slack_id: self.user_id)
        if user
            user.color
        end
    end

    def get_channel_name
        Channel.all.find_by(slack_id: self.channel_id).name
    end

    def datetime
        #Time.at(self.ts.to_f).strftime("%H:%M")
        ### fix
        DateTime.strptime(self.ts,'%s')
    end

    def display
        prompt = TTY::Prompt.new
        system("clear")
        time = Time.at(self.ts.to_f)
        color = self.get_color
        if color == nil
            color = "ffffff"
        end
        puts Rainbow("#{self.get_poster_name} @ #{time.strftime("%I:%M %p")}").color(color)
        puts "-" * 100
        puts self.text
        prompt.keypress("Press any key to return to main menu.")
    end

end