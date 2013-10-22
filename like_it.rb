require 'rubygems'
require 'net/http'
require 'json'

LIKES_FILE = "likes"
PLAYER = (RUBY_PLATFORM == "armv6l-linux-eabihf") ? "omxplayer" : "mpg123"

while true do
  begin
    response = Net::HTTP.get_response("graph.facebook.com","/mikamai")
    json = JSON.parse(response.body)

    old_likes =  File.open(LIKES_FILE, 'r').gets.to_i
    likes = json["likes"].to_i

    if (likes > old_likes)
      #fixme: with mpg123 the -o local option (obviously) returns an error, it's non blocking but could be fixed
      system(PLAYER + " coin.mp3 -o local")
      p "like"
    end

    File.open(LIKES_FILE, 'w') { |file| file.write(likes) }

    sleep (10)
  rescue
    p "ERROR!!! YOU SHOULD INVESTIGATE"
  end
end
