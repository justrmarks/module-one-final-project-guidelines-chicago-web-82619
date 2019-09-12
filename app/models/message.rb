class Message < ActiveRecord::Base
    belongs_to :user, :foreign_key => "user_id"
    belongs_to :channel, :foreign_key => "channel_id"

    def get_poster_name
        user = User.find_by(slack_id: self.user_id)
        if user 
            user.display_name
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
        puts "#{self.get_poster_name} @ #{self.datetime}".colorize(:blue)
        puts "-" * 100
        puts self.text.colorize(:light_green)
        puts " "
        prompt.keypress("Press any key to return to main menu.")
    end

end