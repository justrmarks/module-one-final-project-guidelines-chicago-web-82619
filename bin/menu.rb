class Menu

    def initialize(user)
        @user = user
    end

    def main_menu
    system("clear")
    prompt = TTY::Prompt.new
    choices = [
        {name: "Read your messages", value: 1},
        {name: "Write a message", value: 2},
        {name: "Inspect a channel", value: 3},
        {name: "Exit", value: 4}]
    input = prompt.select("What would you like to do?", choices)
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
        prompt = TTY::Prompt.new
        choices = [
            {name: "All your messages", value: 1},
            {name: "Messages by channel", value: 2},
            {name: "Messages by user", value: 3},
            {name: "Back", value: 4}]
        input = prompt.select("Which messages would you like to read?", choices)
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

    def write_menu
        system("clear")
        puts "write_menu"
    end
    
    def insight_menu
        system("clear")
        puts "insight_menu"
    end

    def exit
       system("clear")
       puts "GOOD BYE" 
    end

end