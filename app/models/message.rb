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
        puts self.text.colorize(:light_green)
        puts " "
        prompt.keypress("Press any key to return to main menu.")
    end

    # should post the message to the slack api
    def post(channel_name)

        payload = {
            "channel": channel_name,
            "text": self.text
        }
        post_header = {
            "Content-type": "application/json",
            "Authorization": "Bearer #{token}"
        }
        post_call = JSON.parse(RestClient.post("https://slack.com/api/chat.postMessage", payload, post_header))



    end

    def encrypt(receiver)
        message = self.text
        key = SecureRandom.random_bytes(32)
        sym_encryption = Encryption::Symmetric.new
        sym_encryption.key = key
        sym_encryption.iv =  "\0"*16   
        public_key = Encryption::PublicKey.new(receiver.public_key)
        enc_message = sym_encryption.encrypt(message) #.force_encoding("UTF-8")
        enc_key = public_key.encrypt(key) #.force_encoding('UTF-8')
        text1 = "Encrypted!" 
        p text1
        text2 = "START #{enc_key}"
        p text2
        text3 = "START #{enc_message}"
        p text3
        message = "#{text1} #{text2} #{text3}"
        

        # post message in #secrets w/o saving in database
        payload = {
            "channel": "#secret",
            "text": message
        }
        post_header = {
            "Content-type": "application/json",
            "Authorization": "Bearer #{token}"
        }
        response = JSON.parse(RestClient.post("https://slack.com/api/chat.postMessage", payload, post_header))
        ts = response["message"]["ts"]
        time = Time.at(ts.to_f)
        self.ts = ts
        self.text = "Encrypted message posted in #secrets @ #{time.strftime("%I:%M %p")}"
        self.subtype = "encrypted"
        self.save
        self
    end

    ## decrypts messages returns self.text if message was decrypted false if message wasn't 
    # encrypted originally
    def decrypt
        data = self.text
        header = data[0..9]
        enc_key = data[16...250]
        enc_text = data[257..data.size]
        ##if header == "Encrypted!"
            if (File.exist?("secret/private.key"))
                f = File.open("secret/private.key")
                private_key = Encryption::PrivateKey.new(f)
                sym_encryption = Encryption::Symmetric.new
                key = private_key.decrypt(enc_key)
                sym_encryption.key = key
                sym_encryption.iv =  "\0"*16    
                self.text =  sym_encryption.decrypt(enc_text)         
                self.post
                self.text
            else
                puts "No keypair found - please login again to generate new keypair"
            end
        #end
        "wrong"
    end



end