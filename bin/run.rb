require_relative '../config/environment'

# gem install rest-client
require 'rest-client'
require 'json'
require 'pry'



################################################################################################################################
# token = "xoxp-747869875793-756141399111-757227574870-afeac009f56b2e827d406f08d0a489dc"
# channel_id = "CMTERPXMY"
# response = RestClient.get("https://slack.com/api/conversations.list?token=#{token}")
# data = JSON.parse(response)

# # Read a message
# messages = RestClient.get("https://slack.com/api/conversations.history?token=#{token}&channel=#{channel_id}")
# message_list = JSON.parse(messages)
# # GET https://slack.com/api/conversations.history
# #   ?token=YOUR_TOKEN_HERE
# #   &channel=CONVERSATION_ID_HERE
# #   &latest=YOUR_TS_VALUE
# #   &limit=1
# #   &inclusive=true


# # Post a message
# payload = {
#     "channel": channel_id,
#     "text": "testing post from api",
#     "as_user": true # makes post come from user associated with api token
# }
# post_header = {
#     "Content-type": "application/json",
#     "Authorization": "Bearer #{token}"
# }
# post_message = RestClient.post("https://slack.com/api/chat.postMessage", payload, post_header)

# # POST https://slack.com/api/chat.postMessage
# # Content-type: application/json
# # Authorization: Bearer YOUR_TOKEN_HERE
# # {
# #   "channel": "YOUR_CHANNEL_ID",
# #   "text": "Hello, world"
# # }




# binding.pry
# true