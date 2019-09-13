User.update_users
Channel.update_channels
Channel.all.each { |channel| channel.update_messages }
