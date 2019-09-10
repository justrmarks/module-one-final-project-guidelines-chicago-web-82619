class User < ActiveRecord::Base
    has_many :messages
    has_many :channels, through: :messages

#   Class Methods

    # method to update database with user name and id
    def self.update_users
        data = JSON.parse(RestClient.get("https://slack.com/api/users.list?token=#{token}"))
        data["members"].each do |member|
            if member["deleted"]
                User.destroy(User.find_by(slack_id: member["id"]).id)
            else
                User.find_or_create_by({
                    slack_id: member["id"],
                    name: member["name"],
                    color: member["color"],
                    email: member["profile"]["email"]
                })
            end
        end
    end

    #method to authenticate user and return a user instance
    def self.login
        puts "Please enter name:"
        name = gets.chomp
        user = all.find_by(name: name)
        if user
            puts "Please enter a password:"
            password = gets.chomp
            if !user.password
                puts "Setting your password...."
                user.update(password: password)
            elsif user.password != password
                puts "Incorrect password"
                self.login
            else
                puts "Signing in #{user.name}"
                sleep 2
            end
        else
            puts "No user found."
            self.login
        end
    end

end