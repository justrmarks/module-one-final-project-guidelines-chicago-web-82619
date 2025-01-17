class Menu
    attr_reader :user

    def initialize(user)
        @user = user
    end

    def main_menu
        User.update_users
        Channel.update_channels
        Channel.all.each { |channel| channel.update_messages }
        system("clear")
        puts "Main Menu"
        puts "-----------------------"
        puts "Signed in as #{self.user.display_name}".colorize(:cyan)
        puts " "
        prompt = TTY::Prompt.new
        choices = [
            {name: "Read messages            ", value: 1},
            {name: "Write a message          ", value: 2},
            {name: "Inspect a channel        ", value: 3},
            {name: "Exit                     ", value: 4}]
        input = prompt.select("What would you like to do?".colorize(:blue), choices, active_color: :inverse)
        case input
            when 1 
                read_menu
            when 2 
                write_menu
            when 3 
                insight_menu
            when 4 
                exit
        end
    end

    def read_menu
        system("clear")
        puts "Signed in as #{self.user.display_name}".colorize(:cyan)
        puts " "
        prompt = TTY::Prompt.new
        choices = [
            {name: "All your messages                    ", value: 1},
            {name: "Messages by channel                  ", value: 2},
            {name: "Messages by user                     ", value: 3},
            {name: "Back                                 ", value: 4}]
        input = prompt.select("Which messages would you like to read?".colorize(:blue), choices, active_color: :inverse)
        puts "-".colorize(:bright_blue) * 38
        case input 
            when 1 
                self.user.display_messages
                main_menu
            when 2 
                channel = self.user.display_channels
                channel.display_messages
                main_menu
            when 3 
                User.display_messages_by_user
                main_menu
            when 4 
                Channel.find_by(name: "#secret").display_encrypted_messages(self.user)
            when 5 
                main_menu
        end
    end

    def write_menu
        system("clear")
        puts "Signed in as #{self.user.display_name}".colorize(:cyan)
        puts " "
        log_user = self.user
        log_user.display_channels.post_message(log_user).display
        main_menu
    end
    
    def insight_menu
        system("clear")
        puts "Signed in as #{self.user.display_name}".colorize(:cyan)
        puts " "
        self.user.display_channels.insights
        main_menu
    end

    def exit
       a = Artii::Base.new :font => "slant"
       8.times {
       system("clear")
       puts a.asciify('Good Bye !')
       puts "\n"
       sleep(0.1)
       system("clear")
       puts a.asciify(' Good Bye !')
       puts "\n"
       sleep(0.1)
    }
    system("clear")
    puts a.asciify('Good Bye !')
    end

end