# SLAPI
## Setup
Run `bundle install` to install dependencies and `rake db:migrate` to create the databases. Finally, run `rake db:seed` to populate the databases with real information from your Slack workspace.

## Getting Started
* Run `ruby bin/run.rb` to start the program.
---
## Models: Channels < Messages > Userss
### Channel
* has_many :messages
* has_many :users, through: :messages
### User
* has_many :messages
* has_many :channels, through: :messages
### Messages
* belongs_to :channel
* belongs_to :user
## Data
### Channels
* `@name` : name of the channel
* `@slack_id` : channel ID
* `@topic` : subject of discussion within the channel
### Users
* `@name` : username (not their full name) usually corresponds to the user's email
* `@slack_id` : user ID
* `@color` : HEX code randomly assigned to each user by slack
* `@email` : user email
* `@password` : user created password
* `@display_name` : display name selected by the user, typically a first or full name
### Messages
* `@ts` : time and date in which the message was posted
* `@text` : body and contents of the message
* `@user_id` : ID of the user who posted the message
* `@channel_id` : ID of the channel in which the message is posted
* `@subtype` : type of message
---
## API
### SLACK
* https://api.slack.com/
