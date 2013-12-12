# Description:
#   Search and Display Relevant Wikipedia Link
#
# Dependencies:
#   request
#
# Configuration:
#   none
#
# Commands:
#   <robot_name> wiki <query>
#
# Notes:
#   None 
#
# Author:
#   rdodev

r = require('request')

base_url = 'http://en.wikipedia.org/w/api.php?'
url_args = '&format=json&action=query&prop=info&inprop=url'


module.exports = (robot) ->
  
    get_wiki = (msg) ->
      req = r.get base_url + 'titles='+ encodeURIComponent(msg.match[1].trim()) + url_args, (error, req, body) ->
          if not error
            handle_response msg, body
          else
            msg.send 'wah wah something broke :~('

    handle_response = (msg, body) ->
        jsn = JSON.parse body
        pages = (p for p of jsn.query.pages when p isnt '-1')
        if pages.length > 0
            text = "Here's the Wikipedia link for #{msg.match[1]}: #{jsn.query.pages[pages[0]].fullurl}"
            msg.send text
        else
            text = "You query #{msg.match[1]} returned no results."
            msg.send text

    robot.respond /wiki (.+)/i, (msg) -> 
        get_wiki msg
